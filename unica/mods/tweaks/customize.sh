# Disable app compaction
# Guard the patch as the source firmware might have this already disabled
LOG "- Applying \"Disable app compaction\" to /system/system/framework/services.jar"
APPLY_PATCH "system" "system/framework/services.jar" \
    "$MODPATH/appcompactor/services.jar/0001-Disable-app-compaction.patch" &> /dev/null || true

# Disable FM Radio country restrictions
if [ "$(GET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_FMRADIO_CONFIG_AVOID_REGION")" ]; then
    SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_FMRADIO_CONFIG_AVOID_REGION" --delete
fi

LOG_STEP_IN "- Applying extreme doze for all apps"
EVAL "find \"\$WORK_DIR\" -type f \( -path '*/etc/permissions/*.xml' -o -path '*/etc/sysconfig/*.xml' \) -exec \
    sed -i -E '/<(allow-(in-(power|data-usage)-save(-except-idle)?|(unthrottled|ignore)-(location|alarms?)(-settings)?|implicit-broadcast|background-activity-starts|auto-restarter|in-app-standby)|(bg-restriction|app-standby|system|cached-app-freezer)-exemption|system-component|auto-start-whitelist)[[:space:]]/d' {} +"

EVAL "sed -i '/<reviewed-in-power-save/d' \"\$WORK_DIR\"/system/system/etc/deviceidle/reviewed_allowlist.xml"
LOG_STEP_OUT


