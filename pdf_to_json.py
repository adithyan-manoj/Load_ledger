import os
import json
import pdfplumber
import re

pdf_dir = 'pdfs'
data = {}

def parse_float(val):
    if not val or val.strip() in ['-', '']:
        return 0.0
    return float(val.replace(',', '').replace(' ', '').strip())

for filename in os.listdir(pdf_dir):
    if not filename.endswith('.pdf'):
        continue
    filepath = os.path.join(pdf_dir, filename)
    
    # Determine branch from filename or text
    branch_name = 'Unknown'
    if 'punalur' in filename.lower():
        branch_name = 'Punalur'
    elif 'adoor' in filename.lower():
        branch_name = 'Adoor'
    elif 'alappuzha' in filename.lower():
        branch_name = 'Alappuzha'
    elif 'kollam' in filename.lower():
        branch_name = 'Kollam'

    records = []
    
    with pdfplumber.open(filepath) as pdf:
        for page_idx, page in enumerate(pdf.pages):
            text = page.extract_text() or ''
            
            # If we still don't know the branch, try the text
            if branch_name == 'Unknown':
                match = re.search(r'The Post Master\s+(.*?)\s+HPO', text, re.IGNORECASE)
                if match:
                    branch_name = match.group(1).strip()
                elif 'Punalur' in text:
                    branch_name = 'Punalur'
                elif 'Adoor' in text:
                    branch_name = 'Adoor'
                elif 'Alappuzha' in text:
                    branch_name = 'Alappuzha'
                elif 'Kollam' in text:
                    branch_name = 'Kollam'

            tables = page.extract_tables()
            for table in tables:
                for row_idx, row in enumerate(table):
                    if not any(row):
                        continue
                    
                    # Skip header row if present
                    if row[0] and ('Memo' in row[0] or 'No' in row[0] or 'M.' in row[0]):
                        continue
                    
                    name_cell = (row[1] or '').strip()
                    if not name_cell or 'Name' in name_cell:
                        continue
                    
                    # Extract customer name (ignore employee ID in parentheses)
                    name = name_cell.split('\n')[0].strip()
                    
                    # Member number: use column 0, or synthesize if missing in column 0
                    member_no = (row[0] or '').split('\n')[0].strip()
                    if not member_no:
                        # Fallback member number for members without printed M. No.
                        clean_name = re.sub(r'[^a-zA-Z0-9]', '', name)
                        member_no = f"M-{clean_name}"
                    
                    ac_lines = (row[2] or '').split('\n')
                    pos_lines = (row[3] or '').split('\n')
                    emi_lines = (row[5] or '').split('\n') if len(row) > 5 else []
                    
                    num_loans = max(len(ac_lines), len(pos_lines), len(emi_lines), 1)
                    
                    for i in range(num_loans):
                        ac = ac_lines[i].strip() if i < len(ac_lines) and ac_lines[i].strip() else f"/25-26-{i}"
                        pos = parse_float(pos_lines[i]) if i < len(pos_lines) else 0.0
                        emi = parse_float(emi_lines[i]) if i < len(emi_lines) else 0.0
                        
                        records.append({
                            'member_no': member_no,
                            'name': name,
                            'account_no': ac,
                            'base_emi': emi,
                            'principal_os': pos
                        })

    if branch_name in data:
        data[branch_name].extend(records)
    else:
        data[branch_name] = records

with open('extracted_data.json', 'w') as f:
    json.dump(data, f, indent=2)

# Also ensure assets/data exists and copy
os.makedirs('assets/data', exist_ok=True)
with open('assets/data/extracted_data.json', 'w') as f:
    json.dump(data, f, indent=2)

print(f"Extraction complete. Extracted branches: {list(data.keys())} with {sum(len(v) for v in data.values())} total records.")
