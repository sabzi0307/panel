{include file='user/header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">دانشنامه</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">آموزش نصب و استفاده را اینجا ببینید</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="row row-deck row-cards">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">لیست مطالب</h3>
                        </div>
                        <div class="list-group list-group-flush list-group-hoverable">
                            {foreach $docs as $doc}
                                <div class="list-group-item">
                                    <div class="row align-items-center">
                                        <div class="col text-truncate">
                                            <div class="text-reset d-block">{$doc->title}</div>
                                            <div class="d-block text-secondary text-truncate mt-n1">
                                                {$doc->date}
                                            </div>
                                        </div>
                                        <div class="col-auto">
                                            <a class="btn btn-blue" href="/user/docs/{$doc->id}/view">
                                                نمایش
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            {/foreach}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

{include file='user/footer.tpl'}
