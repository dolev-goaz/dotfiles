import fs from "fs";
import type { GithubUserResponse } from "./types";
interface AuthTokens {
  "github-copilot": {
    type: "oauth";
    access: string;
    refresh: string;
    expires: number;
  };
}

export function getCopilotToken() {
  const tokenPath = `${process.env.HOME}/.local/share/opencode/auth.json`;
  if (!fs.existsSync(tokenPath)) {
    console.log("Token file not found: ", tokenPath);
    return null;
  }
  try {
    const tokensStr = fs.readFileSync(tokenPath, "utf-8").trim();
    const tokens = JSON.parse(tokensStr) as AuthTokens;
    return tokens["github-copilot"].refresh;
  } catch (e) {
    console.error("Failed to read copilot token", e);
    return null;
  }
}

export async function getCopilotSubscriptionDetails(token: string) {
  try {
    const res = await fetch("https://api.github.com/copilot_internal/user", {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });

    if (!res.ok) {
      throw new Error(
        `Failed to fetch copilot details: ${res.status} ${res.statusText}`,
      );
    }
    return res.json() as Promise<GithubUserResponse>;
  } catch (e) {
    console.error("Error fetching copilot subscription details", e);
    return null;
  }
}
