{if !empty($thumbnails)}{strip}

{html_style}
{* Set size of thumbnails based on chosen photo size *}
#thumbnails li {
{if $derivative_params->type == 'thumb'}
    width: min(100px, 100%);
    margin: 2px;
{elseif $derivative_params->type == '2small'}
    width: min(124px, 100%);
{elseif $derivative_params->type == 'xsmall'}
    width: min(156px, 100%);
{elseif $derivative_params->type == 'small'}
    width: min(190px, 100%);
{elseif $derivative_params->type == 'medium'}
    width: min(230px, 100%);
{elseif strpos("large", $derivative_params->type) !== false}
    width: min(300px, 100%);
{else} /* default as square */
    width: min(156px, 100%);
{/if}
}

{if $derivative_params->type == 'square'}
    .thumbImg img { object-fit: cover; }
{/if}
{/html_style}

{footer_script}
  var error_icon = "{$ROOT_URL}{$themeconf.icon_dir}/errors_small.png", max_requests = {$maxRequests};
{/footer_script}

{foreach from=$thumbnails item=thumbnail}
{* xmall has a better resolution for 156px than the actual square derivatives *}
{assign var=derivative value=$pwg->derivative(($derivative_params->type=='square')?'xsmall':$derivative_params, $thumbnail.src_image)}
{if !$derivative->is_cached()}
{combine_script id='jquery.ajaxmanager' path='themes/default/js/plugins/jquery.ajaxmanager.js' load='footer'}
{combine_script id='thumbnails.loader' path='themes/default/js/thumbnails.loader.js' require='jquery.ajaxmanager' load='footer'}
{*{assign var=ext value=strtolower(substr($thumbnail.file, -4))}*}
{/if}
{assign var="ext" value="{{$thumbnail.file|substr:-4}|strtolower}"}
    <li>
        <div class="thumbImg">
            <img class="thumbnail" 
                {if $derivative->is_cached()}
                    {if $ext == '.svg' || $ext == '.gif'}
                    src="{$thumbnail.path}" {if $derivative_params->type=='square'}style="object-fit: cover;"{/if}
                    {else}
                    src="{$derivative->get_url()}"
                    {/if}
                {else}
                src="{$ROOT_URL}{$themeconf.icon_dir}/img_small.png" data-src="{$derivative->get_url()}"
                {/if} 
                alt="{$thumbnail.TN_ALT}">
        </div>
        <div class="thumbWrap">
            <a href="{$thumbnail.URL}" title="{$thumbnail.NAME}{if !empty($thumbnail.icon_ts)}{"\n"}{$thumbnail.icon_ts.TITLE}{/if}">
                <h4>
                    {if !empty($thumbnail.icon_ts)}
                    <span class="pwg-icon-recent">&nbsp;</span>
                    {/if}
                    {$thumbnail.file}
                </h4>
                {if is_numeric($thumbnail.width) and is_numeric($thumbnail.height)}
                <p>{$thumbnail.width}*{$thumbnail.height}</p>
                {/if}

            {if $derivative_param != 'thumb'}
                {if isset($thumbnail.NB_COMMENTS)}
                <p class="{if 0==$thumbnail.NB_COMMENTS}zero {/if}nb-comments">
                    {$thumbnail.NB_COMMENTS|@translate_dec:'%d comment':'%d comments'}
                </p>
                {/if}

                {if isset($thumbnail.NB_HITS)}
                <p class="{if 0==$thumbnail.NB_HITS}zero {/if}nb-hits">
                    {$thumbnail.NB_HITS|@translate_dec:'%d hit':'%d hits'}
                </p>
                {/if}
            {/if} {* $derivative_param *}
            </a>
        </div>
    </li>
{/foreach}{/strip}
{/if}

