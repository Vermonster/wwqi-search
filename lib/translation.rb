# encoding: utf-8

class Translation < ActiveRecord::Base
  class << self
    if Environment.skip_database
      def lookup(key, locale)
        BY_LOCALE.fetch(locale, {}).fetch(key, key)
      end
    else
      def lookup(*args) ; find_by_key_and_locale(*args) ; end
    end
    alias_method :t, :lookup
  end

  BY_LOCALE = HashWithIndifferentAccess.new(
    en: {
      'born-prefix' => 'b.',
      'died-prefix' => 'd.',
      'do-you-know-this-person' => 'Do you know this person?',
      'help-us-complete-this-profile' => 'Help us complete this profile.',
      'timeline-header' => 'Life events and dated items',
      'view-as-search-results' => 'view as search results',
      'view-item' => 'View item'
    },
    fa: {
      'born-prefix' => 'تواد',
      'died-prefix' => 'مرگ',
      'do-you-know-this-person' => 'این فرد را می‌شناسید؟',
      'help-us-complete-this-profile' => 'به تکمیل اطلاعات این فرد کمک کنید',
      'timeline-header' => 'وقایع زندگی و اقلامِ با تاریخ',
      'view-as-search-results' => 'مشاهده به صورت نتایج جستجو',
      'view-item' => 'مشاهده این سند'
    }
  )
end
