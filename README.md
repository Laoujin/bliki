pongit.be
=========

## Flow

```powershell
# setup:
gem install jekyll bundler

# run:
npm start
bundle exec jekyll serve --drafts

# Show theme path
bundle show minima

# New plugin
# Add to _config.yml and Gemfile
bundle install

# PRD flag
$env:JEKYLL_ENV = "production"
bundle exec jekyll build
```
