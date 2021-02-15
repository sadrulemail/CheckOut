// Code By: Ashik Iqbal
// www.ashik.info

function getReadableFileSizeString(fileSizeInBytes) {
    var i = -1;
    var byteUnits = [' KB', ' MB', ' GB', ' TB', 'PB', 'EB', 'ZB', 'YB'];
    do {
        fileSizeInBytes = fileSizeInBytes / 1024;
        i++;
    } while (fileSizeInBytes > 1024);
    return Math.max(fileSizeInBytes, 0.1).toFixed(2) + byteUnits[i];
}

$(document).ready(function () {
    jQueryInit();
});

function pageLoad(sender, args) {
    if (args.get_isPartialLoad()) jQueryInit();
}

function jQueryInit() {
    $(document).ready(function () {

        // Prevent the backspace key from navigating back.
        $(document).unbind('keydown').bind('keydown', function (event) {
            var doPrevent = false;
            if (event.keyCode === 8) {

                var d = event.srcElement || event.target;
                //alert();
                if ((d.tagName.toUpperCase() === 'INPUT' && (
                    d.type.toUpperCase() === 'TEXT'
                    || d.type.toUpperCase() === 'PASSWORD'))
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

        $('input:text[Watermark]').each(function () {
            $(this).watermark($(this).attr('Watermark'));
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

        $('[data-toggle="tooltip"]').tooltip({html:true});

        //Disable All Combo
        $("select option[value='']").attr('disabled', true);

        $('.Date').datepicker({
            changeMonth: true,
            changeYear: true,
            showButtonPanel: true,
            dateFormat: 'dd/mm/yy',
            showAnim: 'show'
        }).watermark('dd/mm/yyyy');



        //Datepicker Today Problem Resolve
        $.datepicker._gotoToday = function (id) {
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
            //this.removeClass('ui-priority-secondary');
        }
    });

    
    //--------------------------------------------------------------

//        $('.ui-datepicker-current').live('click', function() {
//            var associatedInputSelector = $(this).attr('onclick').replace(/^.*'(#[^']+)'.*/gi, '$1');
//            var $associatedInput = $(associatedInputSelector).datepicker("setDate", new Date());
//            $associatedInput.datepicker("hide");
//        });

}