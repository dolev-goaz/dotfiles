interface Organization {
  login: string;
  name: string;
}
export interface QuotaSnapshot {
  entitlement: number;
  overage_count: number;
  overage_permitted: boolean;
  percent_remaining: number;
  quota_id: string;
  quota_remaining: number;
  remaining: number;
  unlimited: boolean;
  timestamp_utc: string;
}

export interface GithubUserResponse {
  access_type_sku: string;
  analytics_tracking_id: string;
  assigned_date: string;
  can_signup_for_limited: boolean;
  chat_enabled: boolean;
  copilot_plan: string;
  organization_login_list: string[];
  organization_list: Organization[];
  quota_reset_date: string;
  quota_snapshots: {
    chat: QuotaSnapshot;
    completions: QuotaSnapshot;
    premium_interactions: QuotaSnapshot;
  };
  quota_reset_date_utc: string;
}
