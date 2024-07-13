{include file='user/header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">{$doc->title|escape}</h2>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="card card-lg">
                <div class="card-body">
                    <div id="content" class="content">
                        {if !$doc->isMarkdown}
                            <pre>{$doc->content|escape}</pre>
                        {/if}
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

{if $doc->isMarkdown}
<script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const content = `{$doc->content|escape:'javascript'}`;
    document.getElementById('content').innerHTML = marked.parse(content);
});
</script>
{/if}

{include file='user/footer.tpl'}