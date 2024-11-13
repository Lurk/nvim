-- In order to work rust-analyzer must be installed
-- ```sh
-- rustup component add rust-analyzer
-- ```
return {
  'mrcjkb/rustaceanvim',
  version = '^5', -- Recommended
  ft = { 'rust' },
}
