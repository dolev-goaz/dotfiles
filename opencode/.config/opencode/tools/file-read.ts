import { tool } from "@opencode-ai/plugin";

const dotenvFilePathPattern = /\.env$/;

interface ReadFileArgs {
  filePath: string;
  startLine: number;
  endLine?: number;
}

function assertAuthorizedPath(targetPath: string) {
  if (dotenvFilePathPattern.test(targetPath)) {
    throw new Error(
      `Searching inside secret file "${targetPath}" is not allowed.`,
    );
  }
}

export const read = tool({
  description: "Read the contents of a file from the filesystem",
  args: {
    filePath: tool.schema.string().describe("The path to the file to read."),
    startLine: tool.schema
      .number()
      .describe("The starting line number to read from (1-based)."),
    endLine: tool.schema
      .number()
      .optional()
      .describe("The ending line number to read to (inclusive)."),
  },
  async execute(args: ReadFileArgs) {
    const { filePath } = args;
    assertAuthorizedPath(filePath);
    if (args.endLine && args.endLine < args.startLine) {
      throw new Error(
        `endLine (${args.endLine}) cannot be less than startLine (${args.startLine}).`,
      );
    }
    const file = Bun.file(filePath);
    let content: string;
    try {
      content = await file.text();
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : String(error);
      throw new Error(
        `Failed to read file at path "${filePath}": ${errorMessage}`,
      );
    }
    const lines = content.split("\n");
    const startIndex = Math.max(args.startLine - 1, 0);
    const endIndex = args.endLine
      ? Math.min(args.endLine, lines.length)
      : lines.length;
    const selectedLines = lines.slice(startIndex, endIndex);
    return selectedLines.join("\n");
  },
});

interface SearchArgs {
  pattern: string;
  path?: string;
}

export const ripgrep = tool({
  description: "Search for a string pattern in files using Ripgrep (rg).",
  args: {
    pattern: tool.schema
      .string()
      .describe("The regex or string to search for."),
    path: tool.schema
      .string()
      .optional()
      .describe(
        "The file or directory to search in. Defaults to current directory.",
      ),
  },
  async execute(args: SearchArgs) {
    const targetPath = args.path || ".";
    assertAuthorizedPath(targetPath);

    const command = [
      "rg",
      "--line-number",
      "--no-heading",
      "--color=never",
      // exclude .env
      "--glob",
      "!.env*",
      args.pattern,
      targetPath,
    ];

    try {
      const proc = Bun.spawn(command, {
        stdout: "pipe",
        stderr: "pipe",
      });

      const output = await new Response(proc.stdout).text();
      const error = await new Response(proc.stderr).text();

      if (error && !output) {
        throw new Error(error);
      }

      return output || "No matches found.";
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : String(error);
      throw new Error(`Ripgrep failed: ${errorMessage}`);
    }
  },
});

export const grep = tool({
  description: "Search for a string pattern using standard grep.",
  args: {
    pattern: tool.schema.string().describe("The text pattern to search for."),
    path: tool.schema
      .string()
      .optional()
      .describe(
        "The file or directory to search. Defaults to current directory.",
      ),
  },
  async execute(args: SearchArgs) {
    const targetPath = args.path || ".";
    assertAuthorizedPath(targetPath);

    const command = [
      "grep",
      "-r",
      "-n",
      "--exclude=.env*",
      "--exclude-dir=.git",
      args.pattern,
      targetPath,
    ];

    try {
      const proc = Bun.spawn(command, {
        stdout: "pipe",
        stderr: "pipe",
      });

      const output = await new Response(proc.stdout).text();
      return output || "No matches found.";
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : String(error);
      return `Grep executed with message (often means no results): ${errorMessage}`;
    }
  },
});
