{footer_script require='jquery'}{literal}
    var selected = false;
    var blocks = {/literal}{$blocks|@json_encode}{literal};
    var tab={}; var link={}; var pointer={}; var dropdown={};

    if (blocks !== null) {
        jQuery.each(blocks, function(id, block) {
            $menu_block = $("#"+id);
            tab[id] = $menu_block.find("dt");
            link[id] = $menu_block.find("dt a");
            pointer[id] = $menu_block.find("div[class^='pointer']");
            dropdown[id] = $menu_block.find("dd");

            tab[id].click(function(e){
                e.stopPropagation();
                hideAllDropdown(except=id);
                if (dropdown[id].is(":hidden")) { // show dropdown
                    dropdown[id].show();
                    pointer[id].show();
                    link[id].removeClass("selected").addClass("selected");
                    selected = true;

                    // disabled show/hide labels for identification
                    if (id != 'mbIdentification') 
                        toggleLabels(1);

                    // expand menu downwards
                    $("#menu").css('max-height', 'unset');
                    $("#menu").css('justify-content', 'flex-start');

                } else { // hide dropdown
                    if (!(pointer[id].hasClass("is-page")) || $(window).width()<=800)
                        pointer[id].hide();
                    dropdown[id].hide();
                    link[id].removeClass("selected");
                    selected = false;

                    // shrink menu; reset menu to expand end first
                    $("#menu").css('max-height', '500px');
                    $("#menu").css('justify-content', 'flex-end');
                }

                // wrap text only when text exceeds certain length
                dropdown[id].find("a").each(function() {
                    if ($(this).text().length > 50) { // roughly 50 chars
                        $(this).css('white-space', 'normal');
                    }
                });
            });
        });
    }

    // move img up and show labels on hover
    $("#menubar-tabs").hover( function(){toggleLabels(1,true)}, function(){toggleLabels(0,selected)} );

    // reset dropdown and label visibility when user clicks anywhere else
    $(document).click( function(e) {
        hideAllDropdown();
        selected = false; // reset tabs to none selected
        toggleLabels(0, false); // reset all labels to hidden state
    } );

    // mobile menu slider
    $(".nc-icon-menu").click( function(e) {
        e.stopImmediatePropagation();
        hideAllDropdown();
        toggleMenu();
    });


    $(window).resize(function() {
        $("#menu").removeClass("show"); // reset menu to default hidden
        if ($(window).width() > 800) {
            $(".mb-label").each(function() { $(this).hide(); }); // hide labels
            $("#menu").css('max-height', '0px');
        } else {
            $(".mb-label").each(function() { $(this).show(); }); // show labels
            $(".is-page").removeClass("is-page");
        }
    });

    /**
     * Hide all dropdowns
     * @param except Exclude dropdown from hiding
     */
    function hideAllDropdown(except=null) {
        if (blocks !== null) {
            jQuery.each(blocks, function(id, block) {
                if (id != except) {
                    if (dropdown[id].is(":visible")) {
                        if (!(pointer[id].hasClass("is-page")))
                            pointer[id].hide();
                        dropdown[id].hide();
                        link[id].removeClass("selected");
                    }
                }
            });
        }

        // reset max-height to default expanded state
        // reset menu to expand end first
        // only if menu was already expanded (max-height already 500px)
        if ($("#menu").css('max-height') != '0px') {
            $("#menu").css('max-height', '500px');
            $("#menu").css('justify-content', 'flex-end'); // if dropdown showing on click
        }
    }

    /**
     * Toggle label visibility and icon translation
     * @param action 1=show, 0=hide
     * @param selected true=one menu item selected, false=no menu item selected
     */
    function toggleLabels(action, selected) {
        // ignore for mobile screens
        if ($(window).width() <= 800) 
            return;
        
        if (action == 1) { // hover in
            $(".nc-icon-mb").each(function() { $(this).removeClass("translate").addClass("translate"); });
            $(".mb-label").each(function() { $(this).show(); });
            $(".is-page").removeClass("hover").addClass("hover");
        } else if (!selected) { // hover out
            $(".nc-icon-mb").each(function() { $(this).removeClass("translate"); });
            $(".mb-label").each(function() { $(this).hide(); });
            $(".is-page").removeClass("hover");
        }
    }

    /**
     * Toggle mobile screen menu slider
     * @param action 1=show, 0=hide
     */
    function toggleMenu(action) {
        if ($(window).width() > 800) return;
        if ($("#menu").hasClass("show")) {
            $("#menu").css('max-height', '0px');
            $("#menu").removeClass("show");
        } else {
            $("#menu").css('max-height', '500px');
            $("#menu").addClass("show");
        }
    }

{/literal}{/footer_script}


{if !empty($blocks) }
<div id="menubar">
    <div id="galleryTitle">
{*        <a class="mb-logo" href="{$gallery_url}"><img src="https://smartairfilters.com/images/sa-logo.svg"></a> *}
        <a class="mb-logo" href="{$gallery_url}"><img src="{$icons_url}sa-logo.svg"></a>
        <h2><a href="{$gallery_url}">{$gallery_title}</a></h2>
{*        <img class="nc-icon-menu" src="{$icons_url}svg/core/actions/menu?color=fff"> *}
        <img class="nc-icon-menu" src="{$icons_url}menu.svg">
    </div>
    {if !empty($blocks)}
    <div id="menu">
    <div id="menubar-tabs">

{* ======== mbHome ======== *}
        <dl id="mbHome">
<dt><a href="{$gallery_url}">
{*    <img class="nc-icon-mbHome nc-icon-mb" src="{$icons_url}svg/core/places/home?color=fff"> *}
    <img class="nc-icon-mbHome nc-icon-mb" src="{$icons_url}home.svg">
    <span class="mb-label">{'Home'|@translate}</span>
</a></dt>
<div class="pointer{if $is_homepage && $page_section=='categories'} is-page{/if}"></div>
        </dl>

{* ================ *}

        {foreach from=$blocks key=id item=block}
        {if $id!="mbMenu" and $id!="mbIdentification"}
        <dl id="{$id}">

{* ======== mbLinks ======== *}
            {if $id=="mbLinks"}
<dt><a>
{*    <img class="nc-icon-{$id} nc-icon-mb" src="{$icons_url}svg/core/actions/public?color=fff"> *}
    <img class="nc-icon-{$id} nc-icon-mb" src="{$icons_url}public.svg">
    <span class="mb-label">{'Links'|@translate}</span>
</a></dt>
<div class="pointer"></div>
<dd>
    {strip}{foreach from=$block->data item=link}
    <a href="{$link.URL}" class="external"{if isset($link.new_window)} onclick="window.open(this.href, '{$link.new_window.NAME}','{$link.new_window.FEATURES}'); return false;"{/if}>
    {$link.LABEL}
    </a>
    {/foreach}{/strip}
</dd>

{* ======== mbCategories ======== *}
            {elseif $id=="mbCategories"}
<dt>
    <a>
{*        <img class="nc-icon-{$id} nc-icon-mb" src="{$icons_url}apps/deck/img/deck.svg?v=a8813991"> *}
        <img class="nc-icon-{$id} nc-icon-mb" src="{$icons_url}deck.svg">
        <span class="mb-label">{'Albums'|@translate}</span>
    </a>
</dt>
<div class="pointer{if $page_section=='categories' && !$is_homepage} is-page{/if}"></div>
<dd>
<ul>
{foreach from=$block->data.MENU_CATEGORIES item=cat}
    <li {if $cat.SELECTED}class="selected"{/if}">
      <a href="{$cat.URL}" {if $cat.IS_UPPERCAT}rel="up"{/if} title="{$cat.TITLE}" style="padding-left:calc(20px + 1em * {$cat.LEVEL-1})">
      {$cat.NAME} 
      {if $cat.count_images > 0}
      <span class="{if $cat.nb_images > 0}menuInfoCat{else}menuInfoCatByChild{/if} badge" title="{$cat.TITLE}">{$cat.count_images}</span>
      {/if}
      {if !empty($cat.icon_ts)}
      <span class="pwg-icon pwg-icon-recent"></span>
{*      <img class="nc-icon-recent" title="{$cat.icon_ts.TITLE}" src="{$icons_url}svg/files/recent?color=808080" alt="(!)"> *}
      {/if}
      </a>
</li>
{/foreach}
</ul>
    <hr>
    <p class="totalImages">{$block->data.NB_PICTURE|@translate_dec:'%d photo':'%d photos'}</p>
</dd>

{* ======== mbTags ======== *}
            {elseif $id=="mbTags"}
{*            <p>{if isset($page_section)}{$page_section}{else}null{/if}{$is_homepage}</p> *}
<dt><a {if $php_url!='tags.php' && (!isset($page_section) || $is_homepage)}href="{$blocks.mbMenu->data.tags.URL}" title="{$blocks.mbMenu->data.tags.TITLE}"{/if}>
{*    <img class="nc-icon-{$id} nc-icon-mb" src="{$icons_url}svg/core/actions/tag?color=fff"> *}
    <img class="nc-icon-{$id} nc-icon-mb" src="{$icons_url}tag.svg">
    <span class="mb-label">{if $IS_RELATED}{'Related tags'|@translate}{else}{'Tags'|@translate}{/if}</span>
</a></dt>
<div class="pointer{if $page_section=='tags' || $php_url=='tags.php'} is-page{/if}"></div>
{if isset($page_section) && !$is_homepage}
<dd>
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
{/if} {* is_related *}

{* ======== mbSpecials, mbMenu ======== *}
            {elseif $id=="mbSpecials"}
<dt><a>
{*    <img class="nc-icon-{$id} nc-icon-mb" src="{$icons_url}svg/core/actions/more?color=fff"> *}
    <img class="nc-icon-{$id} nc-icon-mb" src="{$icons_url}more.svg">
    <span class="mb-label">{'More'|@translate}</span>
</a></dt>
<div class="pointer"></div>
<dd>
    {strip}
        {if isset($blocks.mbMenu)}
        {foreach from=$blocks.mbMenu->data item=link}{if is_array($link)}
            {if $link.NAME != l10n('Edit photos')}
                <a href="{$link.URL}" title="{$link.TITLE}"{if isset($link.REL)} {$link.REL}{/if}>{$link.NAME}{if isset($link.COUNTER)} ({$link.COUNTER}){/if}</a>
            {/if}
        {/if}{/foreach}
        <hr>
        {/if}
        {foreach from=$block->data item=link}{if $link.NAME != l10n('Your favorites')}
        <a href="{$link.URL}" title="{$link.TITLE}"{if isset($link.REL)} {$link.REL}{/if}>{$link.NAME}</a>
        {/if}{/foreach}
   {/strip}
</dd>

{* ======== mbRelatedCategories ======== *}
            {elseif $id=="mbRelatedCategories"}
<dt><a>
{*    <img class="nc-icon-related-album nc-icon-mb" src="{$icons_url}svg/core/actions/projects?color=fff"> *}
    <img class="nc-icon-related-album nc-icon-mb" src="{$icons_url}projects.svg">
    <span class="mb-label">{'Related albums'|@translate}</span>
</a></dt>
<div class="pointer"></div>
<dd>
    <ul>
    {foreach from=$block->data.MENU_CATEGORIES item=cat}
    <li>
        {if isset($cat.url)}
        <a href="{$cat.url}" title="{$cat.TITLE}" style="padding-left:calc(20px + 1em * {$cat.LEVEL-1})">{parse_lang desc=$cat.name}
        {else}
        <a style="padding-left:calc(20px + 1em * {$cat.LEVEL-1})">{parse_lang desc=$cat.name}
        {/if}
            {if $cat.count_images > 0}
            <span class="badge" title="{$cat.count_images|translate_dec:'%d photo':'%d photos'}">{$cat.count_images}</span>
            {/if}
            {if $cat.count_categories > 0}
            <span class="badge badgeCategories" title="{'sub-albums'|translate}">{$cat.count_categories}</span>
            {/if}
        </a>
    </li>
    {/foreach}
    <ul>
</dd>

{* ======== mbUserCollection ======== *}
            {elseif $id=="mbUserCollection"}
<dt><a>
    <img class="nc-icon-related-album nc-icon-mb" src="{$icons_url}bundles.svg">
    <span class="mb-label">{'Collections'|@translate}</span>
</a></dt>
<div class="pointer"></div>
<dd>
  {strip}
    {if $block->data.NB_COL == 0}
      <a href="{$block->data.U_LIST}">&nbsp;{'You have no collection'|translate}&nbsp;</a>
    {else}
      <a href="{$block->data.U_LIST}">{$pwg->l10n_dec('You have %d collection', 'You have %d collections', $block->data.NB_COL)}</a>
    {/if}
  {/strip}
  {if $block->data.collections}
  <ul>
        {foreach from=$block->data.collections item=col}{strip}
        <li>
      <a href="{$col.u_edit}">{$col.name}
      <span class="menuInfoCat badge">{$col.nb_images}</span>
      </a>
    </li>
        {/strip}{/foreach}
    {if isset($block->data.MORE)}<li class="menuInfoCat"><a href="{$block->data.U_LIST}">{'%d more...'|translate:$block->data.MORE}</a></li>{/if}
    </ul>
  {/if}
</dd>

{* ======== END mb ======== *}

{* ======== Plugins mb ======== *}
            {else}
{if not empty($block->template)}
{include file=$block->template }
{else}
{$block->raw_content}
{/if}

            {/if} {* $id *}
        </dl>
        {/if} {* not mbMenu and mbIdentification *}
        {/foreach} {* $blocks *}

{* ======== Horizontal menu specificities ======== *}
{if isset($blocks.mbSpecials->data.favorites)}
<dl class="horizontal-menu">
    <dt><a href="{$blocks.mbSpecials->data.favorites.URL}" title="{$blocks.mbSpecials->data.favorites.TITLE}">
{*        <img class="nc-icon-favorites nc-icon-mb" src="{$icons_url}svg/core/actions/star-dark?color=fff"> *}
        <img class="nc-icon-favorites nc-icon-mb" src="{$icons_url}star-dark.svg">
        <span class="mb-label">{'Favorites'|@translate}</span>
    </a></dt>
    <div class="pointer{if $page_section=='favorites'} is-page{/if}"></div>
</dl>
{/if}
{foreach from=$blocks.mbMenu->data item=link}{if is_array($link)}
{if $link.NAME == l10n('Edit photos')}
<dl class="horizontal-menu">
    <dt><a href="{$link.URL}" title="{$link.TITLE}">
{*        <img class="nc-icon-edit nc-icon-mb" src="{$icons_url}svg/core/actions/rename?color=fff"> *}
        <img class="nc-icon-edit nc-icon-mb" src="{$icons_url}rename.svg">
        <span class="mb-label">{$link.NAME}</span>
    </a></dt>   
    <div class="pointer{if $page_section=='edit_photos'} is-page{/if}"></div>
</dl>
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
    {if $U_LOGOUT}
    <dt id="tab-mbIdentification">
        <a id="link-mbIdentification">
{*            <img class="nc-icon-user" src="{$icons_url}svg/core/actions/user?color=ffffff"> *}
            <img class="nc-icon-user" src="{$icons_url}user.svg">
            <span>{$USERNAME}</span>
        </a>
    </dt>
    {else}
    <dt>
        <a href="{$U_LOGIN}" rel="nofollow">{'Login'|@translate}</a>
{*            {'Login'|@translate} *}
    </dt>
    {/if}
    <div class="pointer-mbIdentification"></div>
    <dd id="dropdown-mbIdentification">
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
{*
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
            <input type="submit" name="login" value="{'Login'|@translate}">
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
    {/if} // if isset($U_LOGIN)
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
*}
    </dd>
</dl>

{* ======== END ======== *}
    </div>
    {/if}
</div><div id="menuSwitcher"></div>
{/if}
