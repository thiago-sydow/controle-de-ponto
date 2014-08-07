$(function () {

    $('#side-menu').metisMenu();

});

//Loads the correct sidebar on window load,
//collapses the sidebar on window resize.
// Sets the min-height of #page-wrapper to window size
$(function () {
    $(window).bind("load resize", function () {
        topOffset = 50;
        width = (this.window.innerWidth > 0) ? this.window.innerWidth : this.screen.width;
        if (width < 768) {
            $('div.navbar-collapse').addClass('collapse');
            topOffset = 100; // 2-row-menu
        } else {
            $('div.navbar-collapse').removeClass('collapse');
        }

        height = (this.window.innerHeight > 0) ? this.window.innerHeight : this.screen.height;
        height = height - topOffset;
        if (height < 1) height = 1;
        if (height > topOffset) {
            $("#page-wrapper").css("min-height", (height) + "px");
        }
    })
});

$(function () {

    dateSelect = $("#datepicker");

    dateSelect.datepicker({
            onSelect: function (date) {
                $.ajax({
                        type: "PUT",
                        url: "/change_date",
                        data: {date_to_see: date},
                        success: function (result) {
                            $("#date-to-see").text(date);
                            $("#records-table").find("tbody").html(result);
                            dateSelect.toggle();
                        }
                    }
                );

                total_worked = $("#total-worked-hours");

                $.ajax({
                        type: "GET",
                        url: total_worked.data("event-url"),
                        complete: function (result) {
                            total_worked.replaceWith(result.responseText);
                        }
                    }
                );

                remaining_time = $("#remaining_hours");

                $.ajax({
                        type: "GET",
                        url: remaining_time.data("event-url"),
                        complete: function (result) {
                            remaining_time.replaceWith(result.responseText);
                        }
                    }
                );
            }
        },
        $.datepicker.regional[ "pt-BR" ]
    ).hide();

    $("#calendar-link").click(function () {
        dateSelect.toggle();
    });

});

$(function () {
    var g = new JustGage({
        id: "gauge",
        value: -7,
        min: -100,
        max: 100,
        title: "Saldo de Horas",
        hideMinMax: true,
        counter: true,
        noGradient: true,
        customSectors: [
            {
                color: "#ff0000",
                lo: -100,
                hi: -8
            },
            {
                color: "#f9c802",
                lo: -8,
                hi: 8
            },
            {
                color: "#a9d70b",
                lo: 8,
                hi: 100
            }
        ]
    });
});

$(function () {
    $("#monthly-records").dataTable({searching: false, ordering: false, language: { url: '/assets/Portuguese-Brasil.json'}});
});
