import Em from "components-ember"

View = Em.View.extend
    removeLoadings: Em.on "didInsertElement", ->
        $(".waiting-for-ember").remove()

export default View
