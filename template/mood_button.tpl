{if ($enable_mood_switch)}
        {strip}
        <a id="moodSwitch" href="{$mood_switch_url}" title="{$mood_title}" class="pwg-state-default pwg-button" rel="nofollow">
            <span class="pwg-icon pwg-icon-{if $mood=='clear'}moon{else}sun{/if}"></span><span class="pwg-button-text">{$mood_title}</span>
        </a>
        {/strip}
{/if}
