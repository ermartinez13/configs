return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },
    opts = {
      -- Render while reading; Insert and Visual modes show raw Markdown.
      render_modes = { 'n' },
      latex = { enabled = false },
    },
  },
}
