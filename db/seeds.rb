def headlines
  (1..10).map do |n|
    Headline.new({
      title: "Title #{n}",
      url: "http://example.com/headline-#{n}"
    })
  end
end

def snapshots
  (1..10).map do |n|
    Snapshot.new({
      created_at: n.hours.ago,
      thumbnail: "http://example.com/thumbnail-#{n}.jpg",
      filename: "http://example.com/filename-#{n}.jpg",
      headlines: headlines
    })
  end
end

def sites
  (1..10).map do |n|
    Site.new({
      name: "Site #{n}",
      shortcode: "s#{n}",
      url: "http://#{n}.example.com",
      snapshots: snapshots
    })
  end
end

sites.each(&:save)
