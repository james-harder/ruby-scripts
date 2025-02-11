#!/usr/bin/env ruby

traefikMethods = ['Header','HeaderRegexp','Host','HostRegexp','Method','Path','PathPrefix','PathRegexp','Query','QueryRegexp','ClientIP']

rules = []
rules.push('(Host(`something.com`,`something.else.com`) && PathPrefix(`/here/there/`))')
rules.push('PathPrefix(`/api/`)')
rules.push('(Host(`place.com`, `place.us.com`) || Host(`other.place.net`))')
rules.push('(HostRegexp(`{*}us.com`, `{*}.user.com`))')

# puts rules
# if the first character is a LP
#   if the last character is a RP, strip first and last parantheses
#   else it's an error
# else look for Host, HostRegexp, PathPrefix

# strip outer parentheses and back-ticks
rules.each do |rule|
    if rule.end_with?("\)\)")
        # puts "double para close."
        rule.delete_prefix!("\(").delete_suffix!("\)")
    end
    rule.delete!("` ")
end

rules.each do |rule|
    hosts = []

    if hostString = rule[/Host\(.*?\)/]
        hosts = hostString.delete_prefix!("Host\(").delete_suffix!("\)").split(",")
    elsif hostString = rule[/HostRegexp\(.*?\)/]
        hosts = hostString.delete_prefix!("HostRegexp\(").delete_suffix!("\)").split(",")
    end

    if pathString = rule[/PathPrefix\(.*?\)/]
        pathString.delete_prefix!("PathPrefix\(").delete_suffix!("\)").delete_suffix!("/")
    end

    hosts.each do |host|
        if host.start_with?(/\{.*?\}\./)
            puts "#{host.sub(/\{.*?\}/, 'wildcard')}#{pathString}"
        elsif host.start_with?(/\{.*?\}/)
            puts "#{host.sub(/\{.*?\}/, 'wildcard.')}#{pathString}"
            puts "#{host.sub(/\{.*?\}/, '')}#{pathString}"
        else
            puts "#{host}#{pathString}"
        end
    end
end

# puts rules