# YandEx

Library which contains functions interacting with Yandex Translate Api.

## Installation

1. Add yand_ex to your list of dependencies in `mix.exs`:

        def deps do
          [{:yand_ex, git: "https://github.com/philippearnaud/yand-ex.git", tag: "v1.0.0"}
        end

2. Ensure yand_ex is started before your application:

        def application do
          [applications: [:yand_ex]]
        end

