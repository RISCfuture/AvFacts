if Rails.env.development?
  require 'yard'
  YARD::Rake::YardocTask.new do |doc|
    doc.options << '-m' << 'markdown' << '-M' << 'redcarpet'
    doc.options << '--protected' << '--no-private'
    doc.options << '-r' << 'README.md'
    doc.options << '-o' << 'doc/app'
    doc.options << '--title' << "AvFacts Documentation"

    doc.files = %w[app/**/*.rb lib/**/*.rb]
  end
end
