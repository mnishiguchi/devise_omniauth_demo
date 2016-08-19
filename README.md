# Omniauth login demo

## Features
- Log in with email.
- Log in with Twitter etc.
- Four types of dashboard interfaces:
  + users
  + clients
  + account executives
  + admins

## Gem dependencies
- Omniauth
- Devise
- [etc](Gemfile)

## How to run the test suite
```
$ guard
```

---

## Set up gems

### Simple Form

```bash
$ rails generate simple_form:install --bootstrap

# Inside your views, use the 'simple_form_for' with one of the Bootstrap form
# classes, '.form-horizontal' or '.form-inline', as the following:
#
#   = simple_form_for(@user, html: { class: 'form-horizontal' }) do |form|
```

### Devise
- [setup_devise_with_scoped_models](setup_devise_with_scoped_models.md)

### Omniauth
- [setup_omniauth_for_devise](setup_omniauth_for_devise.md)
- [Devise+OmniAuthでQiita風の複数プロバイダ認証](http://qiita.com/mnishiguchi/items/e15bbef61287f84b546e)

### Minitest
- [Use Minitest for Your Next Rails Project](https://mattbrictson.com/minitest-and-rails)
- [4 Fantastic Ways to Set Up State in Minitest](http://chriskottom.com/blog/2014/10/4-fantastic-ways-to-set-up-state-in-minitest/)
- [thoughtbot/shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)
