enum CatalystOutputTypes {
  campaign,
  singlePost,
}

enum CatalystCampaignOutputTypes {
  daily,
  weekly,
  monthly,
  event,
}

Map<CatalystCampaignOutputTypes, String> catalystCampaignOutputOptions = {
  CatalystCampaignOutputTypes.daily: 'Daily Campaign',
  CatalystCampaignOutputTypes.weekly: 'Weekly Campaign',
  CatalystCampaignOutputTypes.monthly: 'Monthly Campaign',
  CatalystCampaignOutputTypes.event: 'Event Promotion',
};

Map<CatalystCampaignOutputTypes, String> catalystCampaignOutputApiEnums = {
  CatalystCampaignOutputTypes.daily: 'REGULAR_REPEATED_DAILY',
  CatalystCampaignOutputTypes.weekly: 'REGULAR_REPEATED_WEEKLY',
  CatalystCampaignOutputTypes.monthly: 'REGULAR_REPEATED_MONTHLY',
  CatalystCampaignOutputTypes.event: 'EVENT',
};
