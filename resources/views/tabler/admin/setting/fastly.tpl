{include file='admin/header.tpl'}
<link rel="stylesheet" href="https://cdn.datatables.net/v/dt/jqc-1.12.4/dt-1.13.6/b-2.4.2/sl-1.7.0/datatables.min.css" />
<link rel="stylesheet" href="/assets/css/editor.dataTables.css">
<script src="https://cdn.datatables.net/v/dt/jqc-1.12.4/dt-1.13.6/b-2.4.2/sl-1.7.0/datatables.min.js"></script>
<script src="/assets/js/dataTables.editor.js"></script>
<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">تونل Fastly</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">دسترسی ها و وضعیت تونل Fastly</span>
                    </div>
                </div>
                <div class="col-auto ms-auto d-print-none">
                    <div class="btn-list">
                        <a id="save-setting" href="#" class="btn btn-primary">
                            <i class="icon ti ti-device-floppy"></i>
                            ذخیره
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="row row-deck row-cards">
                <div class="col-md-12">
                    <div class="card">
                        <div class="card-header">
                            <a>تونل Fastly</a>
                        </div>
                        <div class="card-body">
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table id="data_table" class="table table-vcenter card-table"
                                        width="100%">
                                        <thead>
                                            <tr>
                                                <th style="width: unset;">آدرس IP</th>
                                                <th style="width: unset;">سرور</th>
                                                <th style="width: unset;">عملیات</th>
                                            </tr>
                                        </thead>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal fade" id="userValueModal" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">لطفا مقدار را وارد کنید</h5>
                    </div>
                    <div class="modal-body">
                        <input type="text" class="form-control" id="userValueInput">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" id="submitUserValue">ارسال</button>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal" id="cancelUserValue">انصراف</button>
                    </div>
                </div>
            </div>
        </div>

        <script>
$.fn.dataTable.ext.errMode = 'none';
            var editor = new $.fn.dataTable.Editor({
                ajax: {
                    create: {
                        type: 'POST',
                        url: '/admin/setting/fastly'
                    },
                    edit: {
                        type: 'PUT',
                        url: '/admin/setting/fastly/_id_'
                    },
                    remove: {
                        type: 'DELETE',
                        url: '/admin/setting/fastly/_id_'
                    }
                },
                table: '#data_table',
                idSrc: 'id',
                fields: [
                    { label: 'نام کاربری', name: 'username' },
                    { label: 'رمزعبور', name: 'password' }
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
                }
            });

            var table = $('#data_table')
                .DataTable({
                    ajax: {
                        url: "/admin/setting/fastly/ajax",
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
                        { targets: "_all", defaultContent: "<b>بدون داده</b>" },
                    ],
                    dom: 'Brtip',
                    // data: ,
                    serverSide: false,
                    processing: false,
                    paging: false,
                    scrollCollapse: true,
                    columns: [
                        { data: 'customer_id', className: 'dt-body-right', orderable: false },
                        {
                            data: function(data) {
                                var token = JSON.parse(data.token);
                                return token.access_token;
                            },
                            className: 'dt-body-right',
                            orderable: false,
                            editable: false,
                            editField: "token.access_token",
                        },
                        {
                            data: null,
                            className: 'dt-body-right',
                            defaultContent: '<a href="" class="editor_remove">حذف</a>'
                        }
                    ],
                    select: false,
                    buttons: [
                        { extend: 'create', editor: editor },
                        // { extend: 'edit', editor: editor },
                        // {
                        //     extend: 'selectedSingle',
                        //     text: 'تغییر به IP فعلی',
                        //     action: function(e, dt, node, config) {
                        //         editor
                        //             .edit(table.row({ selected: true }).index(), false)
                        //             .set('ip', "127.0.0.1")
                        //             .submit();
                        //     }
                        // },
                        // { extend: 'remove', editor: editor },
                    ],
                });

                $('#data_table').on('click', 'td:not(:last-child)', function() {
                    editor.bubble(this, ['ip', 'node.id'], {
                        buttons: [{
                            label: 'ثبت',
                            fn: function() {
                                $('#userValueModal').modal('show');
                            }
                        }, {
                            text: 'ثبت آدرس ‌IP فعلی',
                            action: function() {
                                editor
                                    .set('ip', "{$ip}")
                                    .submit();
                            }
                        }]
                    });
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
                })
                .on('error.dt', function(e, settings, techNote, message) {
                    alert('خطا: ' + settings.jqXHR.responseJSON.error);
                    console.log('خطا: ' + settings.jqXHR.responseJSON.error);
                })
                .DataTable();

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
                .on('submitSuccess', function() {
                    table.ajax.reload();
                    alert('تغییرات با موفقیت ذخیره شد.');
                })
                .on('submitError', function() {
                    alert('متاسفانه خطایی رخ داده! لطفا مجددا تلاش کنید و یا به پشتیبانی گزارش دهید.');
                    table.ajax.reload();
                });


                // Handle "ارسال" button click
                $('#submitUserValue').on('click', function() {
                    var userValue = $('#userValueInput').val();
                    var modal = $(this).closest('.modal');
                    modal.modal('hide');

                    // Send Ajax request with the user value
                    $.ajax({
                        url: '/path/to/server-side-script',
                        type: 'POST',
                        data: {
                            userValue: userValue,
                            ip: editor.get('ip'),
                            nodeId: editor.get('node.id')
                        },
                        success: function(response) {
                            console.log('Ajax request succeeded:', response);
                        },
                        error: function(xhr, status, error) {
                            console.error('Ajax request failed:', error);
                        },
                        complete: function() {
                            editor.submit();
                        }
                    });
                });

                // Handle "انصراف" button click
                $('#cancelUserValue').off('click').on('click', function() {
                    var modal = $(this).closest('.modal');
                    modal.modal('hide');
                    // Perform any additional actions if needed
                });
        </script>

{include file='admin/footer.tpl'}