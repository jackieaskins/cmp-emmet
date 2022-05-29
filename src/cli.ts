#!/usr/bin/env node

import expandAbbreviation, { extract, resolveConfig, SyntaxType } from "emmet";
import yargs from "yargs";
import { hideBin } from "yargs/helpers";

interface CompletionParams {
  context: {
    cursor: {
      character: number;
      col: number;
      line: number;
      row: number;
    };
    cursor_before_line: string;
    cursor_line: string;
    filetype: string;
  };
}

const SNIPPET_KIND = 15;
const SNIPPET_FORMAT = 2;
const FILETYPE_MAP: Record<string, { syntax: string; type: SyntaxType }> = {
  html: { syntax: "html", type: "markup" },
  xml: { syntax: "xml", type: "markup" },
  typescriptreact: { syntax: "jsx", type: "markup" },
  javascriptreact: { syntax: "jsx", type: "markup" },
  css: { syntax: "css", type: "stylesheet" },
  sass: { syntax: "css", type: "stylesheet" },
  scss: { syntax: "css", type: "stylesheet" },
  less: { syntax: "css", type: "stylesheet" },
};

const { params, prefix } = yargs(hideBin(process.argv))
  .options({
    params: { type: "string", demand: true },
    prefix: { type: "string" },
  })
  .parseSync();

const {
  context: {
    filetype,
    cursor_line: cursorLine,
    cursor: { character, line },
  },
} = JSON.parse(params) as CompletionParams;

function parse() {
  const { syntax, type } = FILETYPE_MAP[filetype];
  const extracted = extract(cursorLine, character, { type, prefix });

  if (!extracted) {
    return;
  }

  const { abbreviation, start, end } = extracted;
  const emmetConfig = resolveConfig({
    syntax,
    type,
    options: {
      "output.field": (index, placeholder) =>
        `$\{${index}${placeholder ? ":" + placeholder : ""}}`,
    },
  });

  const snippets = new Set([
    abbreviation,
    ...Object.keys(emmetConfig.snippets),
  ]);

  Array.from(snippets).forEach((snippet) => {
    const expanded = expandAbbreviation(snippet, emmetConfig);

    console.log(
      JSON.stringify({
        label: `~${snippet}`,
        insertTextFormat: SNIPPET_FORMAT,
        detail: snippet,
        documentation: { kind: "markdown", value: expanded },
        textEdit: {
          range: {
            start: { line, character: start - 1 },
            end: { line, character: end },
          },
          newText: expanded,
        },
        kind: SNIPPET_KIND,
      })
    );
  });
}

parse();
