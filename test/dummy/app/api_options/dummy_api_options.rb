class DummyApiOptions < LazyDataApi::Options
  server :test, { protocol: 'http://', host: 'localhost', port: '3000' }
end
