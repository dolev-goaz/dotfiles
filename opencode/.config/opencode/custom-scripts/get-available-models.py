#!/usr/bin/env python3

from dataclasses import dataclass
import requests
from bs4 import BeautifulSoup, Tag
import sys
import json

url = "https://docs.github.com/en/copilot/reference/ai-models/supported-models"

@dataclass
class ModelDetails:
    name: str
    multipler: float

def _read_url(url: str):
    try:
        response = requests.get(url)
        response.raise_for_status()
        return response.text
    except requests.exceptions.RequestException as e:
        print(f"Error fetching URL {url}: {e}", file=sys.stderr)
        sys.exit(1)

def _extract_models_from_table(table: Tag):
    table_body = table.find('tbody')
    if not table_body:
        print("No tbody found in the models table", file=sys.stderr)
        sys.exit(1)
    rows = table_body.find_all('tr')
    models: list[ModelDetails] = []
    for row in rows:
        model_name_cell = row.find('th')
        if not model_name_cell:
            print("No th found in the row", file=sys.stderr)
            continue

        data_columns = row.find_all('td')
        if len(data_columns) == 0:
            print("Row does not have enough columns", file=sys.stderr)
            continue
        multiplier_text = data_columns[0].get_text(strip=True)
        model_name = model_name_cell.get_text(strip=True)
        try:
            multiplier = float(multiplier_text)
        except ValueError:
            print(f"Invalid multiplier value: {multiplier_text}", file=sys.stderr)
            continue
        models.append(ModelDetails(name=model_name, multipler=multiplier))

    return models

def extract_models_table(copilot_models_url: str):
    models_page_content = _read_url(copilot_models_url)
    soup = BeautifulSoup(models_page_content, 'html.parser')
    table_header = soup.find('h2', {'id': 'model-multipliers'})
    if not table_header:
        print("No h2 with id 'model-multipliers' found", file=sys.stderr)
        sys.exit(1)
    table_div = table_header.find_next('div', {'class': 'ghd-tool rowheaders'})
    if not table_div:
        print("No div with class 'ghd-tool rowheaders' found after h2", file=sys.stderr)
        sys.exit(1)
    table = table_div.find('table')
    if not table:
        print("No table found in the div", file=sys.stderr)
        sys.exit(1)

    return _extract_models_from_table(table)


if __name__ == "__main__":
    models = extract_models_table(url)
    # print the models as JSON
    json_output = json.dumps([model.__dict__ for model in models], indent=2)
    print(json_output)
