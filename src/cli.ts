#!/usr/bin/env node

import { doComplete } from "vscode-emmet-helper";
import { TextDocument } from "vscode-languageserver-textdocument";
import yargs from "yargs";
import { hideBin } from "yargs/helpers";

const { content, languageId, position, syntax, uri } = yargs(
  hideBin(process.argv)
)
  .options({
    content: { type: "string", demand: true },
    languageId: { type: "string", demand: true },
    position: { type: "string", demand: true },
    syntax: { type: "string", demand: true },
    uri: { type: "string", demand: true },
  })
  .parseSync();

const document = TextDocument.create(uri, languageId, 0, content);
const result = doComplete(document, JSON.parse(position), syntax, {
  showExpandedAbbreviation: "always",
  showAbbreviationSuggestions: true,
  showSuggestionsAsSnippets: true,
});

if (result) {
  console.log(JSON.stringify(result));
}
