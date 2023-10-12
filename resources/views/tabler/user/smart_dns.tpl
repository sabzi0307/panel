{include file='user/header.tpl'}

<link rel="stylesheet" type="text/css"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet"
    href="https://cdn.datatables.net/v/dt/jqc-1.12.4/dt-1.13.6/b-2.4.2/sl-1.7.0/datatables.min.css" />

<link rel="stylesheet" href="/assets/css/editor.dataTables.css">

<script src="https://cdn.datatables.net/v/dt/jqc-1.12.4/dt-1.13.6/b-2.4.2/sl-1.7.0/datatables.min.js"></script>
<script src="/assets/js/dataTables.editor.min.js"></script>


<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">لیست ها</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">
                            لیست تمام سرور های سیستم
                        </span>
                    </div>
                </div>
                <div class="col-auto ms-auto d-print-none">
                    <div class="btn-list">
                        <a href="/admin/node/create" class="btn btn-primary">
                            <i class="icon ti ti-plus"></i>
                            افزودن
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="col-sm-6">
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">{$ip}</h3>
                    </div>
                    <div class="card-body p-0" style="margin: 30px;">
                        <div class="table-responsive">
                            <table id="data_table" class="compact hover" cellspacing="0" width="100%">
                                <thead>
                                    <tr>
                                        {foreach $details['field'] as $key => $value}
                                            <th>{$value}</th>
                                        {/foreach}
                                        <th></th>
                                        <th></th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        $.fn.dataTable.ext.errMode = 'none';
        var editor = new $.fn.dataTable.Editor({
            ajax: "/user/dns",
            table: '#data_table',
            idSrc: 'id',
            fields: [
                { label: 'آدرس IP', name: 'ip' }
            ],
            i18n: {
                create: {
                    button: "افزودن",
                    title: "افزودن IP جدید",
                    submit: "ثبت"
                },
                edit: {
                    button: "ویرایش",
                    title: "ویرایش آدرس IP",
                    submit: "ثبت"
                },
                remove: {
                    button: "حذف",
                    title: "حذف IP",
                    submit: "حذف",
                    confirm: {
                        _: "شما در حال حذف %d گزینه هستید. آیا تایید میفرمایید؟",
                        1: "شما در حال حذف یک گزینه هستید. آیا تایید میفرمایید؟",
                    }
                },
                error: {
                    system: "خطا در سرور! لطفا با پشتیبانی مطرح فرمایید."
                },
                multi: {
                    title: "Plusieurs valeurs",
                    info: "Les éléments sélectionnés contiennent des valeurs différentes pour cette entrée. Pour modifier et mettre tous les éléments pour cette entrée pour la même valeur, cliquez ou appuyez ici, sinon ils vont conserver leurs valeurs individuelles.",
                    restore: "Annuler les modifications"
                },
            }
        });

        var table = $('#data_table')
            .DataTable({
                ajax: {
                    url: "/user/dns/ajax",
                    type: "POST",
                    contentType: "application/json",
                    dataType: "json",
                    error: function(xhr, error, thrown) {
                        if (xhr.responseJSON.ret !== null && xhr.responseJSON.ret === 0) {
                            if (xhr.responseJSON.msg !== "") {
                                alert("خطا " + xhr.status + " :" + xhr.responseJSON.msg);
                            } else {
                                alert("خطا " + xhr.status + " :" + thrown);
                            }
                        } else {
                            alert(error + xhr.status + " : " + thrown);
                        }
                    }
                },
                columnDefs: [
                    //default content for all columns in case of empty or data not found
                    { targets: "_all", defaultContent: "<b>بدون داده</b>" },
                ],
                dom: 'Bfrtip',
                // data: data,
                serverSide: false,
                processing: false,
                columns: [
                    { data: 'ip', className: 'dt-body-right', orderable: false },
                    { data: 'mark', className: 'dt-body-right', orderable: false },
                    { data: 'updated_at', className: 'dt-body-right', orderable: false },
                    {
                        data: null,
                        className: 'center',
                        defaultContent: '<a href="" class="editor_edit_to">ویرایش به آدرس فعلی</a> / <a href="" class="editor_edit">ویرایش</a> / <a href="" class="editor_remove">حذف</a>'
                    }
                ],
                select: {
                    style: 'single',
                },
                buttons: [
                    { extend: 'create', editor: editor },
                    { extend: 'edit', editor: editor },
                    {
                        extend: 'selectedSingle',
                        text: 'تغییر به IP فعلی',
                        action: function(e, dt, node, config) {
                            editor
                                .edit(table.row({ selected: true }).index(), false)
                                .set('ip', "127.0.0.1")
                                .submit();
                        }
                    },
                    { extend: 'remove', editor: editor },
                ],
            });

        // Activate an inline edit on click of a table cell
        $('#data_table')
            // .on('click', 'tbody td:first-child', function(e) {
            //     // editor.inline(this, {
            //     //     buttons: { label: 'به روزرسانی', fn: function() { this.submit(); } }
            //     // });
            //     editor.bubble(this, );
            // })
            .on('click', 'tbody td:first-child', function() {
                editor.bubble(this, ['ip', 'id'], {
                    buttons: [{
                            label: 'ثبت',
                            fn: function() {
                                editor.submit();
                            }
                        },
                        {
                            text: 'ثبت آدرس ‌IP فعلی',
                            action: function() {
                                editor
                                    // .field('ip').val('127.0.01')
                                    .set('ip', "127.0.0.1")
                                    .submit();
                            }
                        }
                    ]
                });
            })

            // Edit record
            .on('click', 'a.editor_edit', function(e) {
                e.preventDefault();

                editor
                    .title('Edit record')
                    .buttons({
                        label: 'Update',
                        fn: function() {
                            editor.submit();
                        }
                    })
                    .edit($(this).closest('tr'));
            })

            // Edit record
            .on('click', 'a.editor_edit_to', function(e) {
                // e.preventDefault();

                editor
                    .edit($(this).closest('tr'))
                    .set('ip', "127.0.0.1")
                    .submit();
            })

            // Delete a record
            .on('click', 'a.editor_remove', function(e) {
                e.preventDefault();

                editor
                    .title('حذف گزینه')
                    .message('آیا از حذف این گزینه اطمینان دارید ؟')
                    .buttons({
                        label: 'حذف',
                        fn: function() {
                            editor.submit();
                        }
                    })
                    .remove($(this).closest('tr'));
            });

            // .on('error.dt', function(e, settings, techNote, message) {
            //     alert('خطا: ' + settings.jqXHR.responseJSON.error);
            //     console.log('خطا: ' + settings.jqXHR.responseJSON.error);
            // })
            // .DataTable();

        var openVals;
        editor
            .on('open', function(e, type) {
                openVals = JSON.stringify(editor.get());
            })
            .on('preBlur', function(e) {
                if (openVals !== JSON.stringify(editor.get())) {
                    return confirm('شما یک تغییر ذخیره نشده دارید! آیا از خروج اطمینان دارید؟');
                }
            })
            // .on('submitSuccess', function() {
            //     table.ajax.reload();
            //     alert('تغییرات با موفقیت ذخیره شد.');
            // })
            .on('submitError', function() {
                alert('متاسفانه خطایی رخ داده! لطفا مجددا تلاش کنید و یا به پشتیبانی گزارش دهید.');
                table.ajax.reload();
            });


        function loadTable() {
            table;
        }

        function deleteIP(node_id) {
            $('#notice-message').text('آیا مطمئن هستید که می خواهید این سرور را حذف کنید؟');
            $('#notice-dialog').modal('show');
            $('#notice-confirm').off('click').on('click', function() {
                $.ajax({
                    url: "/user/node/" + node_id,
                    type: 'DELETE',
                    dataType: "json",
                    success: function(data) {
                        if (data.ret === 1) {
                            $('#success-noreload-message').text(data.msg);
                            $('#success-noreload-dialog').modal('show');
                            reloadTableAjax();
                        } else {
                            $('#fail-message').text(data.msg);
                            $('#fail-dialog').modal('show');
                        }
                    }
                })
            });
        }

        function updateIP(node_id) {
            $.ajax({
                url: "/user/dns/" + node_id,
                type: 'PUT',
                dataType: "json",
                data: {
                    {foreach $update_field as $key}
                        {$key}: $('#{$key}').val(),
                    {/foreach}
                    type: $("#type").is(":checked"),
                    custom_config: JSON.stringify(editor.get()),
                },
                success: function(data) {
                    if (data.ret === 1) {
                        $('#success-message').text(data.msg);
                        $('#success-dialog').modal('show');
                        window.setTimeout("location.href=top.document.referrer", {$config['jump_delay']});
                    } else {
                        $('#fail-message').text(data.msg);
                        $('#fail-dialog').modal('show');
                    }
                }
            })
        }

        function reloadTableAjax() {
            table.ajax.reload(null, false);
        }

        loadTable();
    </script>

{include file='user/footer.tpl'}