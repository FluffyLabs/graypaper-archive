import * as fs from "node:fs/promises";

const EXPECTED_ARGUMENTS_N = 4;
const INPUT_PATTERN = /Input:([0-9]+):\/workspace\/graypaper\/.\/(.+\.tex)/;
const START_PAGE_PATTERN = /\{([0-9]+)$/;
const VERTICAL_BLOCK_PATTERN =
  /\[([0-9]+),([0-9]+):(-?[0-9]+),(-?[0-9]+):(-?[0-9]+),(-?[0-9]+),(-?[0-9]+)/;
const HORIZONTAL_BLOCK_PATTERN =
  /\(([0-9]+),([0-9]+):(-?[0-9]+),(-?[0-9]+):(-?[0-9]+),(-?[0-9]+),(-?[0-9]+)/;
const DOCUMENT_WIDTH_IN_SYNCTEX_UNITS = 39158297.17696512;
const DOCUMENT_HEIGHT_IN_SYNCTEX_UNITS = 55381020.29313637;

function synctexToObject(synctex) {
  const lines = synctex.split("\n");
  const result = {
    files: {},
    pages: {},
  };

  let currentPage = 0;

  for (let i = 0; i < lines.length; i++) {
    let matches: string[];

    matches = lines[i].match(INPUT_PATTERN);
    if (matches) {
      result.files[matches[1]] = matches[2];
      continue;
    }

    matches = lines[i].match(START_PAGE_PATTERN);
    if (matches) {
      currentPage = Number.parseInt(matches[1]);
      result.pages[currentPage] = [];
      continue;
    }

    matches =
      lines[i].match(VERTICAL_BLOCK_PATTERN) ||
      lines[i].match(HORIZONTAL_BLOCK_PATTERN);
    if (matches) {
      result.pages[currentPage].push({
        fileId: Number.parseInt(matches[1]),
        line: Number.parseInt(matches[2]),
        left: Number.parseInt(matches[3]) / DOCUMENT_WIDTH_IN_SYNCTEX_UNITS,
        top: Number.parseInt(matches[4]) / DOCUMENT_HEIGHT_IN_SYNCTEX_UNITS,
        width: Number.parseInt(matches[5]) / DOCUMENT_WIDTH_IN_SYNCTEX_UNITS,
        height: Number.parseInt(matches[6]) / DOCUMENT_HEIGHT_IN_SYNCTEX_UNITS,
        pageNumber: currentPage,
        index: result.pages[currentPage].length,
      });
    }
  }

  return result;
}

async function main() {
  if (process.argv.length !== EXPECTED_ARGUMENTS_N) {
    throw new Error("Unexpected number of arguments.");
  }

  const [srcPath, destPath] = process.argv.slice(-2);

  try {
    const synctex = await fs.readFile(srcPath, {
      encoding: "utf8",
    });

    const result = synctexToObject(synctex);

    await fs.writeFile(destPath, JSON.stringify(result));
  } catch (error) {
    console.error(error);
  }
}

main();
