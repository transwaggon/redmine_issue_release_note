function hideReleaseNoteFieldText(fieldId) {
  // console.log(fieldId)
  var element = $(".text_cf.cf_"+fieldId+".attribute")
  if (element) element.addClass("hidden")
}
window.hideReleaseNoteFieldText = hideReleaseNoteFieldText
