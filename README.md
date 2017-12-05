[![Code Climate](https://img.shields.io/codeclimate/maintainability/anomaly/jekyll-reload.svg?style=for-the-badge)](https://codeclimate.com/github/anomaly/jekyll-reload/maintainability)
![Gem Version](https://img.shields.io/gem/v/jekyll-reload.svg?style=for-the-badge)
![Gem DL](https://img.shields.io/gem/dt/jekyll-reload.svg?style=for-the-badge)

# Jekyll Reload

Jekyll Reload is a modern, simple, and to the point take on LiveReload for Jekyll.  There is no adding of scripts to your source, there is just using LiveReload, and booting your site with the server in development, and then having your browser connect to the LiveReload after your site becomes available to browser (most of the time this will be automatic if you've already enabled LiveReload for the port before).

## Usage

```ruby
gem "jekyll-reload", {
  group: "jekyll-plugins"
}
```

### In your Layout `<head>`
#### W/ Jekyll-Assets

```html
{% asset livereload.js %}
```

#### Vendor

```html
{% livereload %}
```

#### Addon

1. Download the [Browser Plugin](https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei)
2. Click to enable.

## Config

```yaml
reloader:
  error_file: nil
  host: Jekyll::Site#config["host"]
  port: 35729
```

***The Reloader can return an error page, if you designate one, this is will allow you to customize the error message you see in development, or to serve up your standard error page for consistency, if you want.  It should be the relative path from your source, and part of Jekyll.***
