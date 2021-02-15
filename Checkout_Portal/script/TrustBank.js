// Code By: Ashik Iqbal
// www.ashik.info

function htmlEscape(str) {
    //return str.text();
    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/\\/g, '&#92;')
        ;
}

function printDocument(printDiv) {
    var printContents = document.getElementById(printDiv).innerHTML;
    var originalContents = document.body.innerHTML;
    document.body.innerHTML = printContents;
    window.print();
    document.body.innerHTML = originalContents;
    setTimeout(function () { window.close(); }, 100);
}


function getReadableFileSizeString(fileSizeInBytes) {
    var i = -1;
    var byteUnits = [' KB', ' MB', ' GB', ' TB', 'PB', 'EB', 'ZB', 'YB'];
    do {
        fileSizeInBytes = fileSizeInBytes / 1024;
        i++;
    } while (fileSizeInBytes > 1024);
    return Math.max(fileSizeInBytes, 0.1).toFixed(2) + byteUnits[i];
}

function showLoadingDialog(titleText) {
    $("#loading").dialog({
        modal: true,
        height: 210,
        width: 240,
        resizable: false,
        draggable: false,
        title: titleText,
        closeOnEscape: false,
        disabled: true
    });
    $(".ui-dialog-titlebar-close").hide();
}

function hideLoadingDialog() {
    $("#loading").dialog("close");
    $("#loading").dialog("destroy");
}

$(document).ready(function () {
    jQueryInit();
});

//function pageLoad() {
//    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(jQueryInit);
//}

function pageLoad(sender, args) {
    if (args.get_isPartialLoad()) jQueryInit();
}

function jQueryInit() {
    $(document).ready(function () {

        //var auth = localStorage.getItem('auth');
        //if (auth) {
        //    if (document.domain === 'localhost')
        //        if (auth) document.cookie = 'auth=' + auth + ';domain=localhost;path=/';
        //        else document.cookie = 'auth=' + auth + ';domain=.tblbd.com;path=/';
        //    //else localStorage.setItem('auth', $('#hidAuth').val());
        //}

        // Prevent the backspace key from navigating back.
        $(document).unbind('keydown').bind('keydown', function (event) {
            var doPrevent = false;
            if (event.keyCode === 8) {

                var d = event.srcElement || event.target;
                //alert();
                if ((d.tagName.toUpperCase() === 'INPUT'
                    //&& (
                    //d.type.toUpperCase() === 'TEXT'
                    //|| d.type.toUpperCase() === 'PASSWORD')
                    )
                    || d.tagName.toUpperCase() === 'TEXTAREA'
                    || $(d).hasClass("editable")
                    ) {
                    doPrevent = d.readOnly
                    || d.disabled;
                }
                else {
                    doPrevent = true;
                }
            }
            if (doPrevent) {
                event.preventDefault();
            }
        });
    });

    $('.div-preview a').each(function () {
        $(this).attr("target", "_blank");
        $(this).addClass('link');
    });


    $('input:text[Watermark]').each(function () {
        $(this).attr('placeholder', $(this).attr('Watermark'));
    });

    //Refresh Challenge Key
    $('#ImgChallengeReload,#ImgChallenge').click(function () {
        $('#ImgChallenge').attr('src', 'Images/loading1.gif');
        $('#ctl00_ContentPlaceHolder2_txtCaptcha').val('').focus();
        setTimeout(function () {
            $('#ImgChallenge').attr('src', 'captcha.ashx?rand=' + Math.random());
        }, 100);
    });
    $('#ImgChallenge').attr('src', 'captcha.ashx?rand=' + Math.random());
    $('#ctl00_ContentPlaceHolder2_txtCaptcha').val('');


    $("time.timeago").timeago();
    $('#ctl00_ContentPlaceHolder2_GridView1_ctl02_txtPassportUpdateReason').val('');

    //Disable All Combo
    $("select option[value='']").attr('disabled', true);

        $('.Date').datepicker({
            changeMonth: true,
            changeYear: true,
            showButtonPanel: true,
            dateFormat: 'dd/mm/yy'
        });
        
        $('.Date').attr('placeholder', 'dd/mm/yyyy');
        

        
//        Datepicker Today Problem Resolve
        $.datepicker._gotoToday = function(id) {
            var target = $(id);
            var inst = this._getInst(target[0]);
            if (this._get(inst, 'gotoCurrent') && inst.currentDay) {
                inst.selectedDay = inst.currentDay;
                inst.drawMonth = inst.selectedMonth = inst.currentMonth;
                inst.drawYear = inst.selectedYear = inst.currentYear;
            }
            else {
                var date = new Date();
                inst.selectedDay = date.getDate();
                inst.drawMonth = inst.selectedMonth = date.getMonth();
                inst.drawYear = inst.selectedYear = date.getFullYear();
                this._setDateDatepicker(target, date);
                this._selectDate(id, this._getDateDatepicker(target));
            }
            this._notifyChange(inst);
            this._adjustDate(target);
            this.removeClass('ui-priority-secondary');
        }
    //--------------------------------------------------------------

//        $('.ui-datepicker-current').live('click', function() {
//            var associatedInputSelector = $(this).attr('onclick').replace(/^.*'(#[^']+)'.*/gi, '$1');
//            var $associatedInput = $(associatedInputSelector).datepicker("setDate", new Date());
//            $associatedInput.datepicker("hide");
//        });

    $('#cmdPrint').click(function () {
        var options = { mode: 'popup', popClose: '', extraCss: 'CSS/StyleSheetPrint.css' };
        $Div_PrintArea = $('#print-div');
        $("input[type='text']", $Div_PrintArea).each(function () {
            this.setAttribute('value', $(this).val());
            $(this).replaceWith("<b>" + this.value + "</b>");
        });
        $('#print-div').printArea(options);
    });

    $('.cmd-Attachment-show').click(function () {
        $('.cmd-Attachment-show').hide();
        $('.div-Attachment-Add').show('Slow');
    });
    $('.cmd-Attachment-hide').click(function () {
        $('.div-Attachment-Add').hide('Slow');
        $('.cmd-Attachment-show').show();
    });

    $('table [ui]').buttonset();


    setTimeout(function () {
        $('.ms-drop').html('');

        $('select[multiple=multiple]').multipleSelect({
            placeholder: 'please select',
            filter: true,
            single: false
        });

        $('select[multiple!=multiple]').each(function () {
            if ($(this).find('option').length > 7 && !$(this).is(':disabled'))
                $(this).multipleSelect({
                    placeholder: 'please select',
                    filter: true,
                    single: true
                });
        });
        $('.ms-drop').hide();
    }, 100);

    //var ip = new java.net.InetAddress.getLocalHost();

    //$('.BrowserInformation').html(browser + ' ' + $.browser.version);

    try {
        pageReady();
    } catch (e) { }


}