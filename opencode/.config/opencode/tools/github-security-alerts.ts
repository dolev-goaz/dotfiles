import { tool, type ToolContext } from "@opencode-ai/plugin";

interface BaseListArgs {
  repo?: string;
  offset?: number;
  limit: number;
}
interface ListDependencyArgs extends BaseListArgs {}
interface ListCodeScanningArgs extends BaseListArgs {}

async function getCurrentRepository() {
  const repo =
    await Bun.$`gh repo view --json nameWithOwner | jq -r '.nameWithOwner'`.text();
  return repo.trim();
}

async function listDependencyAlerts(
  repo: string,
  limit: number,
  offset?: number,
) {
  offset ??= 0;
  const jqFlags = `[
      .[] | {
        number: .number,
        severity: .security_advisory.severity,
        package: .dependency.package.name,
        scope: .dependency.scope,
        vulnerable_range: .security_advisory.vulnerabilities[0].vulnerable_version_range,
        fixed_version: .security_advisory.vulnerabilities[0].first_patched_version.identifier,
        summary: .security_advisory.summary,
        cve: .security_advisory.cve_id,
        manifest_path: .dependency.manifest_path
      }
  ]`;
  const ghArgs = {
    state: "open",
  };
  const ghArgsStr = Object.entries(ghArgs)
    .map(([key, value]) => `${key}=${encodeURIComponent(value)}`)
    .join("&");
  const ghPath = `repos/${repo}/dependabot/alerts?${ghArgsStr}`;
  const alerts: any[] =
    await Bun.$`gh api "${ghPath}" | jq -r ${jqFlags}`.json();
  alerts.sort((a, b) => b.number - a.number);
  return alerts.slice(offset, offset + limit);
}

async function listCodeScanningAlerts(
  repo: string,
  limit: number,
  offset?: number,
) {
  offset ??= 0;
  const jqFlags = `[
      .[] | {
        number: .number,
        severity: .rule.severity,
        tool: .tool.name,
        summary: .rule.description,
        location: .most_recent_instance.location,
        message: .most_recent_instance.message.text,
      }
  ]`;
  const ghArgs = {
    state: "open",
  };
  const ghArgsStr = Object.entries(ghArgs)
    .map(([key, value]) => `${key}=${encodeURIComponent(value)}`)
    .join("&");
  const ghPath = `repos/${repo}/code-scanning/alerts?${ghArgsStr}`;
  const alerts: any[] =
    await Bun.$`gh api "${ghPath}" | jq -r ${jqFlags}`.json();
  alerts.sort((a, b) => b.number - a.number);
  return alerts.slice(offset, offset + limit);
}

export const list_code_scanning = tool({
  description:
    "List code scanning alerts from a GitHub repository (or current)",
  args: {
    repo: tool.schema
      .string()
      .describe(
        "The GitHub repository in the format owner/repo. If not provided, uses the current repository.",
      )
      .optional(),
    offset: tool.schema
      .number()
      .describe("Number of results to skip (default: 0)")
      .optional(),
    limit: tool.schema.number().describe("Number of results to return"),
  },
  async execute(args: ListCodeScanningArgs) {
    const { repo, offset, limit } = args;
    const repository = repo || (await getCurrentRepository());
    const alerts = await listCodeScanningAlerts(repository, limit, offset);
    return JSON.stringify(alerts, null, 2);
  },
});

export const list_dependency_alerts = tool({
  description: "List dependency alerts from a GitHub repository (or current)",
  args: {
    repo: tool.schema
      .string()
      .describe(
        "The GitHub repository in the format owner/repo. If not provided, uses the current repository.",
      )
      .optional(),
    offset: tool.schema
      .number()
      .describe("Number of results to skip (default: 0)")
      .optional(),
    limit: tool.schema.number().describe("Number of results to return"),
  },
  async execute(args: ListDependencyArgs) {
    const { repo, offset, limit } = args;
    const repository = repo || (await getCurrentRepository());
    const alerts = await listDependencyAlerts(repository, limit, offset);
    return JSON.stringify(alerts, null, 2);
  },
});

if (module === require.main) {
  list_code_scanning
    .execute({ limit: 50 }, null as any as ToolContext)
    .then((result) => console.log(result))
    .catch((error) => console.error(error));
}
