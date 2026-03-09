import { tool } from "@opencode-ai/plugin";

interface ListArgs {
  repo?: string;
  limit: number;
  offset?: number;
}

async function getCurrentRepository() {
  const repo =
    await Bun.$`gh repo view --json nameWithOwner | jq -r '.nameWithOwner'`.text();
  return repo.trim();
}

async function listSecurityAlerts(
  repo: string,
  limit: number,
  offset?: number,
) {
  const jqFlags = `[
    .[] | select(.state == "open") | {
        number: .number,
        severity: .security_advisory.severity,
        package: .dependency.package.name,
        scope: .dependency.scope,
        vulnerable_range: .security_advisory.vulnerabilities[0].vulnerable_version_range,
        fixed_version: .security_advisory.vulnerabilities[0].first_patched_version.identifier,
        summary: .security_advisory.summary,
        cve: .security_advisory.cve_id,
        manifest: .dependency.manifest_path
    }
]`;
  const alertsStr =
    await Bun.$`gh api repos/${repo}/dependabot/alerts | jq -r ${jqFlags}`.text();
  const alerts = JSON.parse(alertsStr) as any[];
  offset ??= 0;

  return alerts.slice(offset, offset + limit);
}

export const list = tool({
  description: "List security alerts from a GitHub repository (or current)",
  args: {
    limit: tool.schema.number().describe("Number of security alerts to list."),
    repo: tool.schema
      .string()
      .describe(
        "The GitHub repository in the format owner/repo. If not provided, uses the current repository.",
      )
      .optional(),
    offset: tool.schema
      .number()
      .describe(
        "The number of security alerts to skip before starting to list. Useful for pagination.",
      )
      .optional(),
  },
  async execute(args: ListArgs) {
    const { repo, limit, offset } = args;
    const repository = repo || (await getCurrentRepository());
    const alerts = await listSecurityAlerts(repository, limit, offset);
    return JSON.stringify(alerts, null, 2);
  },
});
