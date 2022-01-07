FROM bitwalker/alpine-elixir:latest

# Set exposed ports
EXPOSE 4000
ENV PORT=4000

# Ensure latest versions of Hex/Rebar/Phx_new are installed on build
ONBUILD RUN mix do local.hex --force, local.rebar --force

# Cache elixir deps
ADD mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

ADD . .

# Run compile and digest assets
RUN cd - && \
    mix do compile, phx.digest

USER default

CMD ["mix", "phx.server"]
