{footer_script}
  var error_icon = "{$ROOT_URL}{$themeconf.icon_dir}/errors_small.png", max_requests = {$maxRequests};
{/footer_script}
<div class="loader"><img src="{$ROOT_URL}{$themeconf.img_dir}/ajax_loader.gif"></div>
<ul class="thumbnailCategories">
{foreach from=$category_thumbnails item=cat name=cat_loop}
{*{assign var=derivative value=$pwg->derivative($derivative_params, $cat.representative.src_image)}*}
{assign var=derivative value=$pwg->derivative('2small', $cat.representative.src_image)}
{if !$derivative->is_cached()}
{combine_script id='jquery.ajaxmanager' path='themes/default/js/plugins/jquery.ajaxmanager.js' load='footer'}
{combine_script id='thumbnails.loader' path='themes/default/js/thumbnails.loader.js' require='jquery.ajaxmanager' load='footer'}
{/if}   
    <li>
        <div class="illustration">
            <img {if $derivative->is_cached()}
{assign var="ext" value="{{$cat.representative.path|pathinfo:PATHINFO_EXTENSION}|strtolower}"}
                     {if $ext=='svg' || $ext=='webp'}
                     src="{$cat.representative.path}"
                     {else}
                     src="{$derivative->get_url()}"
                     {/if}
                 {else}
                 src="{$ROOT_URL}{$themeconf.icon_dir}/img_small.png" data-src="{$derivative->get_url()}"
                 {/if} 
                alt="{$cat.TN_ALT}" title="{$cat.NAME|@replace:'"':' '|@strip_tags:false} - {'display this album'|@translate}">
        </div>
        <div class="description">
            <a href="{$cat.URL}" title="{$cat.NAME}: {$cat.count_images|@translate_dec:'%d image':'%d images'} {$cat.count_categories|@translate_dec:'in %d sub-album':'in %d sub-albums'}{if !empty($cat.icon_ts)}{"\n"}{$cat.icon_ts.TITLE}{/if}">
{*                <img class="nc-icon-folder" src="https://box.smartairfilters.com/apps/files/img/app.svg?v=a8813991"> *}
                <img class="nc-icon-folder" src="./themes/clouds/icon/nextcloud/folder{if $themeconf.colorscheme=='dark'}-blue{/if}.svg">
                <h2>
                    {if !empty($cat.icon_ts)}
                    <span class="pwg-icon-recent"></span>
                    {/if}
                    {$cat.NAME}
                </h2>
                <p>
{*                    {if $cat.count_images}{$cat.count_images|@translate_dec:'%d photo':'%d photos'}{if $cat.nb_categories}, {/if}{/if} *}
                    {if $cat.count_images}{$cat.count_images|@translate_dec:'%d image':'%d images'}{if $cat.nb_categories}, {/if}{/if}
                    {if $cat.nb_categories}
                    <span>{$cat.nb_categories|@translate_dec:'%d sub-album':'%d sub-albums'}</span>
                    {/if}
                </p>
            </a>
        </div>
    </li>
{/foreach}
</ul>

