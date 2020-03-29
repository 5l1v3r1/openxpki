import Em from "components-ember"
import moment from "moment"

Component = Em.Component.extend
    format: "DD.MM.YYYY HH:mm"

    options: {}

    setup: Em.on "didInsertElement", ->
        value = @get "content.value"
        if value is "now"
            @set "content.pickvalue", moment().utc().format @get "format"
        else if value
            @set "content.pickvalue", moment.unix(value).utc().format @get "format"
        Em.run.next =>
            @$().find(".date").datetimepicker
                format: @get "format"

    propagate: Em.observer "content.pickvalue", ->
        if @get("content.pickvalue") and not  @get("content.value")
           @set "content.pickvalue", moment().utc().format @get "format"
           @$().find(".date").data("DateTimePicker").setDate(@get("content.pickvalue"))

        if @get("content.pickvalue") and @get("content.pickvalue") isnt "0"
            datetime = moment.utc(@get("content.pickvalue"), @get("format")).unix()
        else
            datetime = ""
        @set "content.value", datetime

export default Component
