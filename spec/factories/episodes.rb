FactoryBot.define do
  factory :episode do
    transient do
      audio { Rails.root.join('spec', 'fixtures', 'audio.aif') }
      image { Rails.root.join('spec', 'fixtures', 'image.jpg') }
    end

    title { FFaker::CheesyLingo.title }
    description { FFaker::CheesyLingo.paragraph(5) }

    after :build do |episode, evaluator|
      episode.audio.attach(io: evaluator.audio.open, filename: 'audio.aif', content_type: 'audio/aiff') if evaluator.audio
      episode.image.attach(io: evaluator.image.open, filename: 'image.png', content_type: 'image/png') if evaluator.image
    end
  end
end
