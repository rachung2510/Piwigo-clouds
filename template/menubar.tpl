{footer_script require='jquery'}{literal}
    var selected = false;
    var blocks = {/literal}{$blocks|@json_encode}{literal};

    if (blocks !== null) {
        jQuery.each(blocks, function(id, block) {
            $("#tab-"+id).click(function(e){
                e.stopPropagation();
                hideAllDropdown(except=id);
                if ($("#dropdown-"+id).is(":hidden")) {
                    $("#dropdown-"+id).show();
                    $(".pointer-"+id).show();
                    $("#link-"+id).removeClass("selected").addClass("selected");
                    selected = true;
                    if (id != 'mbIdentification') toggleLabels(1);
                } else {
                    $(".pointer-"+id).hide();
                    $("#dropdown-"+id).hide();
                    $("#link-"+id).removeClass("selected");
                    selected = false;
                }

                $("#dropdown-"+id).find("a").each(function() {
                    if ($(this).text().length > 60) { // roughly 60 chars
                        $(this).css('white-space', 'normal');
                    }
                });
            });

        });
    }

    $("#menubar-tabs").hover( function(){toggleLabels(1,true)}, function(){toggleLabels(0,selected)} );

    $(document).click( function() {
        hideAllDropdown();
        selected = false;
        toggleLabels(0, false);
    } );


    function hideAllDropdown(except=null) {
        if (blocks !== null) {
            jQuery.each(blocks, function(id, block) {
                if (id != except) {
                    if ($("#dropdown-"+id).is(":visible")) {
                        $(".pointer-"+id).hide();
                        $("#dropdown-"+id).hide();
                        $("#link-"+id).removeClass("selected");
                    }
                }
            });
        }
    }

    function toggleLabels(action, selected) {
        if ($(window).width() <= 480) {
            return;
        }
        if (action == 1) {
            $(".nc-icon-mb").each(function() { $(this).removeClass("translate").addClass("translate"); });
            $(".mb-label").each(function() { $(this).show(); });
        } else if (!selected) {
            $(".nc-icon-mb").each(function() { $(this).removeClass("translate"); });
            $(".mb-label").each(function() { $(this).hide(); });
        }
    }

{/literal}{/footer_script}


{if !empty($blocks) }
<div id="menubar">
    <div id="galleryTitle">
        <h2><a href="{$gallery_url}">{$gallery_title}</a></h2>
        <img class="nc-icon-menu" src="{$icons_url}svg/core/actions/menu?color=fff">
    </div>
    <div id="navmenu">
    </div>
    {if !empty($blocks)}
    <div id="menu">
    <div id="menubar-tabs">
        {foreach from=$blocks key=id item=block}
        {if $id!="mbMenu" and $id!="mbIdentification"}
        <dl id="{$id}">

{* ======== mbLinks ======== *}
            {if $id=="mbLinks"}
<dt id="tab-{$id}"><a id="link-{$id}">
    <img class="nc-icon-{$id} nc-icon-mb" src="{$icons_url}svg/core/actions/public?color=fff">
    <span class="mb-label">{'Links'|@translate}</span>
</a></dt>
<div class="pointer-{$id}"></div>
<dd id="dropdown-{$id}">
    {strip}{foreach from=$block->data item=link}
    <a href="{$link.URL}" class="external"{if isset($link.new_window)} onclick="window.open(this.href, '{$link.new_window.NAME}','{$link.new_window.FEATURES}'); return false;"{/if}>
    {$link.LABEL}
    </a>
    {/foreach}{/strip}
</dd>

{* ======== mbCategories ======== *}
            {elseif $id=="mbCategories"}
<dt id="tab-{$id}">
{*
    {if isset($U_START_FILTER)}
    <a href="{$U_START_FILTER}" class="pwg-state-default pwg-button menubarFilter" title="{'display only recently posted photos'|@translate}" rel="nofollow"><span class="pwg-icon pwg-icon-filter"> </span></a>
    {/if}
    {if isset($U_STOP_FILTER)}
    <a href="{$U_STOP_FILTER}" class="pwg-state-default pwg-button menubarFilter" title="{'return to the display of all photos'|@translate}"><span class="pwg-icon pwg-icon-filter-del"> </span></a>
    {/if}
*}
    <a id="link-{$id}">
        <img class="nc-icon-{$id} nc-icon-mb" src="{$icons_url}apps/deck/img/deck.svg?v=a8813991">
        <span class="mb-label">{'Albums'|@translate}</span>
    </a>
</dt>
<div class="pointer-{$id}"></div>
<dd id="dropdown-{$id}">
{assign var='ref_level' value=0}
<ul>
{foreach from=$block->data.MENU_CATEGORIES item=cat}
    <li {if $cat.SELECTED}class="selected"{/if}">
      <a href="{$cat.URL}" {if $cat.IS_UPPERCAT}rel="up"{/if} title="{$cat.TITLE}" style="padding-left:calc(20px + 1em * {$cat.LEVEL-1})">
      {$cat.NAME} 
      {if $cat.count_images > 0}
      <span class="{if $cat.nb_images > 0}menuInfoCat{else}menuInfoCatByChild{/if} badge" title="{$cat.TITLE}">{$cat.count_images}</span>
      {/if}
      {if !empty($cat.icon_ts)}
      <img class="nc-icon-recent" title="{$cat.icon_ts.TITLE}" src="{$icons_url}svg/files/recent?color=808080" alt="(!)">
      {/if}
      </a>
  {assign var='ref_level' value=$cat.LEVEL}
</li>
{/foreach}
</ul>
    <hr>
    <p class="totalImages">{$block->data.NB_PICTURE|@translate_dec:'%d photo':'%d photos'}</p>
</dd>

{* ======== mbTags ======== *}
            {elseif $id=="mbTags"}
<dt id="tab-{$id}"><a id="link-{$id}">
    <img class="nc-icon-{$id} nc-icon-mb" src="{$icons_url}svg/core/actions/tag?color=fff">
    <span class="mb-label">{if $IS_RELATED}{'Related tags'|@translate}{else}{'Tags'|@translate}{/if}</span>
</a></dt>
<div class="pointer-{$id}"></div>
<dd id="dropdown-{$id}">
    <div id="menuTagCloud">
        {foreach from=$block->data item=tag}{strip}
            <a class="tagLevel{$tag.level}" href=
            {if isset($tag.U_ADD)}
                "{$tag.U_ADD}" title="{$tag.counter|@translate_dec:'%d photo is also linked to current tags':'%d photos are also linked to current tags'}" rel="nofollow">+
            {else}
                "{$tag.URL}" title="{'display photos linked to this tag'|@translate}">
            {/if}
                {$tag.name}</a>{/strip}
        {/foreach}
    </div>
</dd>

{* ======== mbSpecials, mbMenu ======== *}
            {elseif $id=="mbSpecials"}
<dt id="tab-{$id}"><a id="link-{$id}">
    <img class="nc-icon-{$id} nc-icon-mb" src="{$icons_url}svg/core/actions/more?color=fff">
    <span class="mb-label">{'More'|@translate}</span>
</a></dt>
<div class="pointer-{$id}"></div>
<dd id="dropdown-{$id}">
    {strip}
        {foreach from=$block->data item=link}{if $link.NAME!='Your favorites'}
        <a href="{$link.URL}" title="{$link.TITLE}"{if isset($link.REL)} {$link.REL}{/if}>{$link.NAME}</a>
        {/if}{/foreach}
        {if isset($blocks.mbMenu)}
        <hr>
        {foreach from=$blocks.mbMenu->data item=link}{if is_array($link)}
            {if $link.NAME != "Edit photos"}
                <a href="{$link.URL}" title="{$link.TITLE}"{if isset($link.REL)} {$link.REL}{/if}>{$link.NAME}{if isset($link.COUNTER)} ({$link.COUNTER}){/if}</a>
            {/if}
        {/if}{/foreach}
        {/if}
    {/strip}
</dd>

{* ======== mbRelatedCategories ======== *}
            {elseif $id=="mbRelatedCategories"}
<dt id="tab-{$id}"><a id="link-{$id}">
    <img class="nc-icon-related-album nc-icon-mb" src="{$icons_url}svg/core/actions/projects?color=fff">
    <span class="mb-label">{'Related albums'|@translate}</span>
</a></dt>
<div class="pointer-{$id}"></div>
<dd id="dropdown-{$id}">
{assign var='ref_level' value=0}
{foreach from=$block->data.MENU_CATEGORIES item=cat}
  {if $cat.LEVEL > $ref_level}
  <ul>
  {else}
    </li>
    {'</ul></li>'|@str_repeat:($ref_level-$cat.LEVEL)}
  {/if}
    <li>
  {if isset($cat.url)}
      <a href="{$cat.url}" title="{$cat.TITLE}">{$cat.name}
  {else}
      <a>{$cat.name}
  {/if}
  {if $cat.count_images > 0}
      <span class="badge" title="{$cat.count_images|translate_dec:'%d photo':'%d photos'}">{$cat.count_images}</span>
  {/if}
  {if $cat.count_categories > 0}
      <span class="badge badgeCategories" title="{'sub-albums'|translate}">{$cat.count_categories}</span>
  {/if}
      </a>
  {assign var='ref_level' value=$cat.LEVEL}
{/foreach}
{'</li></ul>'|@str_repeat:$ref_level}
</dd>

{* ======== END mb ======== *}
            {/if} {* $id *}
        </dl>
        {/if} {* not mbMenu and mbIdentification *}
        {/foreach} {* $blocks *}

{* ======== Horizontal menu specificities ======== *}
{if isset($blocks.mbSpecials->data.favorites)}
<dl><dt><a href="{$blocks.mbSpecials->data.favorites.URL}" title="{$blocks.mbSpecials->data.favorites.TITLE}">
    <img class="nc-icon-favorites nc-icon-mb" src="{$icons_url}svg/core/actions/star-dark?color=fff">
    <span class="mb-label">{'Favorites'|@translate}</span>
</a></dt></dl>
{/if}
{foreach from=$blocks.mbMenu->data item=link}{if is_array($link)}
{if $link.NAME == 'Edit photos'}
<dl><dt><a href="{$link.URL}" title="{$link.TITLE}">
    <img class="nc-icon-edit nc-icon-mb" src="{$icons_url}svg/core/actions/rename?color=fff">
    <span class="mb-label">{$link.NAME}</span>
</a></dt></dl>
{/if}
{/if}{/foreach}

    </div> {* menubar-tabs *}


{* ======== Search ======== *}
<dl id="qsearch-bar">
    <form style="margin:0;display:inline" action="{$ROOT_URL}qsearch.php" method=get id=quicksearch onsubmit="return this.q.value!='';">
        <input type="text" name=q id=qsearchInput placeholder="{'Search'|@translate|escape:'html'}..." {if !empty($QUERY_SEARCH)} value="{$QUERY_SEARCH}"{/if}>
    </form>
</dl>

{* ======== Identification ======== *}
<dl id="mbIdentification">
    <dt id="tab-{$id}"><a id="link-{$id}">
        {if $U_LOGOUT}
            <img class="nc-icon-user" src="{$icons_url}svg/core/actions/user?color=ffffff" alt="user">
            <span>{$USERNAME}</span>
        {else}
            {'Login'|@translate}
        {/if}
    </a></dt>
    <div class="pointer-{$id}"></div>
    <dd id="dropdown-{$id}">
    {strip}
        {if isset($USERNAME)}
        <p>{'Hello'|@translate} {$USERNAME} !</p>
        {/if}
            {if isset($U_REGISTER)}
            <a href="{$U_REGISTER}" title="{'Create a new account'|@translate}" rel="nofollow">{'Register'|@translate}</a>
            {/if}
            {if isset($U_LOGIN)}
            <a href="{$U_LOGIN}" rel="nofollow">{'Login'|@translate}</a>
            {/if}
            {if isset($U_LOGOUT)}
            <a href="{$U_LOGOUT}">{'Logout'|@translate}</a>
            {/if}
            {if isset($U_PROFILE)}
            <a href="{$U_PROFILE}" title="{'customize the appareance of the gallery'|@translate}">{'Customize'|@translate}</a>
            {/if}
            {if isset($U_ADMIN)}
            <a href="{$U_ADMIN}" title="{'available for administrators only'|@translate}">{'Administration'|@translate}</a>
            {/if}
    {/strip}
    {if isset($U_LOGIN)}
    {strip}
        <form method="post" action="{$U_LOGIN}" id="quickconnect">
        <fieldset>
        <legend>{'Quick connect'|@translate}</legend>
        <div>
            <label for="username">{'Username'|@translate}</label><br>
          <input type="text" name="username" id="username" value="" style="width:99%">
        </div>

        <div>
            <label for="password">{'Password'|@translate}</label><br>
            <input type="password" name="password" id="password" style="width:99%">
        </div>

        {if $AUTHORIZE_REMEMBERING}
        <div><label for="remember_me">
                <input type="checkbox" name="remember_me" id="remember_me" value="1"> {'Auto login'|@translate}
        </label></div>
        {/if}

        <div>
            <input type="hidden" name="redirect" value="{$smarty.server.REQUEST_URI|@urlencode}">
            <input type="submit" name="login" value="{'Submit'|@translate}">
            <span class="categoryActions">
            {if isset($U_REGISTER)}
            <a href="{$U_REGISTER}" title="{'Create a new account'|@translate}" class="pwg-state-default pwg-button" rel="nofollow">
                <span class="pwg-icon pwg-icon-register"> </span>
            </a>
            {/if}
            <a href="{$U_LOST_PASSWORD}" title="{'Forgot your password?'|@translate}" class="pwg-state-default pwg-button">
                <span class="pwg-icon pwg-icon-lost-password"> </span>
            </a>
            </span>
        </div>

        </fieldset>
        </form>
    {/strip}
    {/if} {* if isset($U_LOGIN) *}
    </dd>
</dl>

{* ======== END ======== *}
    </div>
    {/if}
</div><div id="menuSwitcher"></div>
{/if}
