setTypeAndGo = (type) ->
  Meteor.call 'setTypeUser', type

  if Session.get('fromWhere')
    Router.go Session.get('fromWhere')
    Session.set('fromWhere', undefined)
  else
    Router.go AccountsEntry.settings.dashboardRoute

Template.fanLogin.events
  'click .btn-athlete': ->
    setTypeAndGo('athlete')

  'click .btn-sponsor': ->
    setTypeAndGo('brand')


Template.fanLogin.helpers
  setted: () ->
    Session.get 'iam'

Template.fanLogin.rendered = ->
  Session.set 'iam'

checkUserAndType = () ->
    Meteor.userId() && _.isUndefined(Meteor.user().type())

Template.customSignInWrapper.helpers
  loggedInNotType: ()->
    checkUserAndType()

Template.customSignUpWrapper.helpers
  loggedInNotType: ()->
    checkUserAndType()



