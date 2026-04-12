import { tool } from "@opencode-ai/plugin";

async function getGitHubSessionKey() {
  const output = await Bun.$`${import.meta.dir}/get-github-cookie.sh`.quiet();
  if (output.exitCode !== 0) {
    const errorComponents = [
      "Error retrieving GitHub session cookie:",
      `Exit code: ${output.exitCode}`,
      `Stdout: ${output.stdout}`,
      `Stderr: ${output.stderr}`,
      `Make sure you are authenticated to GitHub in the browser.`,
    ];
    throw new Error(errorComponents.join("\n"));
  }
  return output.text().trim();
}

interface ListArgs {
  limit?: number;
  repo?: string;
  assignee?: string;
}

export const list = tool({
  description: "List issues from a GitHub repository(or current)",
  args: {
    limit: tool.schema
      .number()
      .describe("Number of issues to list. If not provided, lists all issues.")
      .optional(),
    repo: tool.schema
      .string()
      .describe(
        "The GitHub repository in the format owner/repo. If not provided, uses the current repository.",
      )
      .optional(),
    assignee: tool.schema
      .string()
      .describe(
        "Filter issues assigned to a specific user. If not provided, lists all issues. use @me for issues assigned to the current user.",
      )
      .optional(),
  },
  async execute(args: ListArgs) {
    const { limit, repo } = args;
    // Build argument arrays dynamically
    const repoArgs = repo ? ["--repo", repo] : [];
    const limitArgs = limit ? ["--limit", limit.toString()] : [];
    console.log(
      `gh issue list ${repoArgs} ${limitArgs} --json number,title,state,url | jq "."`,
    );
    const result =
      await Bun.$`gh issue list ${repoArgs} ${limitArgs} --json number,title,state,url | jq "."`.text();
    return result.trim();
  },
});

export const getIssue = tool({
  description: "Get details of a GitHub issue in the current repository",
  args: {
    issue: tool.schema
      .string()
      .describe("The issue number in the format #issue_number"),
  },
  async execute(args: { issue: string }) {
    let issue = args.issue;
    issue = issue.startsWith("#") ? issue.slice(1) : issue;
    const result =
      await Bun.$`gh issue view ${issue} --json number,title,body,state,assignees,labels,comments | jq "."`.text();
    return result.trim();
  },
});

interface GetAttachmentsArgs {
  attachmentURL: string | string[];
}
export const getAttachments = tool({
  description:
    "Fetch attachments from a GitHub issue given their URLs. Can handle single or multiple URLs.",

  args: {
    attachmentURL: tool.schema
      .union([
        tool.schema.string().describe("A single attachment URL."),
        tool.schema.array(
          tool.schema.string().describe("An array of attachment URLs."),
        ),
      ])
      .describe(
        "The URL(s) of the attachment(s) to retrieve. Can be a single string or an array of strings.",
      ),
  },
  async execute(args: GetAttachmentsArgs): Promise<string> {
    const urls = Array.isArray(args.attachmentURL)
      ? args.attachmentURL
      : [args.attachmentURL];
    if (urls.length === 0) {
      throw new Error("No attachment URLs provided.");
    }
    const sessionKey = await getGitHubSessionKey();
    const results = await Promise.all(
      urls.map(async (url, index) => {
        const result = await Bun.fetch(url, {
          headers: {
            cookie: `user_session=${sessionKey}`,
          },
        });
        if (!result.ok) {
          throw new Error(`Failed to fetch attachment from URL: ${url}`);
        }
        // store the file in .agent with a unique name based on the URL
        const urlPath = new URL(url).pathname;
        const fileName = urlPath.substring(urlPath.lastIndexOf("/") + 1);
        const uniqueSuffix = Date.now();

        const extensionStart = fileName.indexOf(".");
        const baseName =
          extensionStart !== -1
            ? fileName.substring(0, extensionStart)
            : fileName;
        const extension =
          extensionStart !== -1 ? fileName.substring(extensionStart) : "";
        const filePath = `agent_artifacts/${baseName}-${index}-${uniqueSuffix}${extension}`;

        Bun.write(filePath, await result.arrayBuffer());
        return { url, filePath };
      }),
    );
    return JSON.stringify(results);
  },
});

interface CreateBranchArgs {
  issue: string;
  branchName: string;
}

export const createBranch = tool({
  description:
    "Create a new Git branch from a GitHub issue in the current repository and check into it",
  args: {
    issue: tool.schema
      .string()
      .describe("The issue number in the format #issue_number"),
    branchName: tool.schema
      .string()
      .describe("The name of the new branch to create."),
  },
  async execute(args: CreateBranchArgs) {
    const { branchName } = args;
    let issue = args.issue;
    issue = issue.startsWith("#") ? issue.slice(1) : issue;
    await Bun.$`gh issue develop ${issue} --name "${branchName}"`.quiet();
    await Bun.$`~/scripts/git-worktree-add.sh ${branchName}`.quiet();
    return `Branch ${branchName} created and checked out in a new worktree.`;
  },
});

if (import.meta.main) {
  const res = await getAttachments.execute(
    {
      attachmentURL:
        "https://github.com/user-attachments/files/25391857/-.1.xlsx",
    },
    {} as any,
  );
  console.log(res);
}
