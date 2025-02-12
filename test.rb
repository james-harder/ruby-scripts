#!/usr/bin/env ruby

rules = []
rules.push('(Host(`something.com`,`something.else.com`) && PathPrefix(`/here/there/`))')
rules.push('PathPrefix(`/api/`)')
rules.push('(Host(`place.com`, `place.us.com`) || Host(`other.place.net`))')
rules.push('(HostRegexp(`{*}us.com`, `{*}.user.com`))')

tenant = 'wildcard'
urls = []

rules.each do |rule|

    if rule.end_with?("\)\)")
        rule.delete_prefix!("\(").delete_suffix!("\)")
    end
    rule.delete!("` ")

    if pathString = rule[/PathPrefix\(.*?\)/]
        pathString.delete_prefix!("PathPrefix\(").delete_suffix!("\)").delete_suffix!("/")
    else
        pathString = ''
    end

    rule.scan(/Host\(.*?\)/).each do |hostString|
        hostString.delete_prefix!("Host\(").delete_suffix!("\)").split(",").each do |host|
            puts "#{host}#{pathString}"
        end
    end

    rule.scan(/HostRegexp\(.*?\)/).each do |hostString|
        hostString.delete_prefix!("HostRegexp\(").delete_suffix!("\)").split(",").each do |host|
            if host.start_with?(/\{.*?\}\./)
                urls.push(host.sub(/\{.*?\}/, tenant).concat(pathString))
            elsif host.start_with?(/\{.*?\}/)
                urls.push(host.sub(/\{.*?\}/, "#{tenant}.").concat(pathString))
                urls.push(host.sub(/\{.*?\}/, '').concat(pathString))
            else
                urls.push(host.concat(pathString))
            end
        end
    end
end

puts urls