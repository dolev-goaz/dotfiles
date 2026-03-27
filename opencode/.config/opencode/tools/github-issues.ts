import { tool } from "@opencode-ai/plugin";

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
