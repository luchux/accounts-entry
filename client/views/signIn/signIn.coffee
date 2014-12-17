AccountsEntry.entrySignInHelpers = {
  emailInputType: ->
    if AccountsEntry.settings.passwordSignupFields is 'EMAIL_ONLY'
      'email'
    else
      'string'

  emailPlaceholder: ->
    fields = AccountsEntry.settings.passwordSignupFields

    if _.contains([
      'USERNAME_AND_EMAIL'
      'USERNAME_AND_OPTIONAL_EMAIL'
      ], fields)
      return t9n("usernameOrEmail")
    else if fields == "USERNAME_ONLY"
      return t9n("username")

    return t9n("email")

  logo: ->
    AccountsEntry.settings.logo

  isUsernameOnly: ->
    return AccountsEntry.settings.passwordSignupFields == 'USERNAME_ONLY'

}

AccountsEntry.entrySignInEvents = {
  'submit #signIn': (event, template) ->
    event.preventDefault()

    email = template.$('input[name="email"]').val()
    if (AccountsEntry.isStringEmail(email) and AccountsEntry.settings.emailToLower) or
     (not AccountsEntry.isStringEmail(email) and AccountsEntry.settings.usernameToLower)
      email = email.toLowerCase()

    Session.set('email', email)
    Session.set('password', template.$('input[name="password"]').val())

    Meteor.loginWithPassword(Session.get('email'), Session.get('password'), (error)->
      Session.set('password', undefined)
      if error
        T9NHelper.accountsError error
      else if Meteor.user().type()
        if Session.get('fromWhere')
          Router.go Session.get('fromWhere')
          Session.set('fromWhere', undefined)
        else
          Router.go AccountsEntry.settings.dashboardRoute
      else
        Session.set('iam')
        if Router.current()?.location?.get()?.originalUrl is not '/'
            Router.go '/'

    )
}

Template.entrySignIn.helpers(AccountsEntry.entrySignInHelpers)

Template.entrySignIn.events(AccountsEntry.entrySignInEvents)
