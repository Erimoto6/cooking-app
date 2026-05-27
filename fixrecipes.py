"""
fixrecipes.py
-------------
Converts the original recipe text file to the new [DISH_ID:] format.
Run this ONCE to create the cleaned file, then use import_recipes.py to import.

Usage:
    python fixrecipes.py
"""

import re
import os

INPUT_FILE = "Cooking_Application_Drafts__1_.txt"
OUTPUT_FILE = "Cooking_Application_Cleaned.txt"

# Map region codes
REGION_CODES = {
    'Philippines': 'PH',
    'South Korea': 'KR',
    'Japan': 'JP',
    'China': 'CN',
    'Indonesia': 'ID',
    'Nigeria': 'NG',
    'South Africa': 'ZA',
    'Egypt': 'EG',
    'Australia': 'AU',
    'New Zealand': 'NZ',
    'Fiji': 'FJ',
    'France': 'FR',
    'Germany': 'DE',
    'Italy': 'IT',
    'Canada': 'CA',
    'United States': 'US',
    'Mexico': 'MX',
    'Brazil': 'BR',
    'Argentina': 'AR',
    'Chile': 'CL',
}

COURSE_CODES = {
    'Main Course': 'M',
    'Dessert': 'D',
    'Beverage': 'B',
}

def generate_dish_id(region, course, sequence):
    region_code = REGION_CODES.get(region, 'XX')
    course_code = COURSE_CODES.get(course, 'X')
    return f"{region_code}_{course_code}{sequence:02d}"

def parse_old_format_to_new():
    with open(INPUT_FILE, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    output_lines = []
    output_lines.append("[FILE_VERSION:1.0]")
    output_lines.append("[FORMAT:ID|TITLE|CATEGORY|SUBCATEGORY|INGREDIENTS|PROCEDURE]")
    output_lines.append("")
    
    current_section = None
    current_region = None
    current_course = None
    current_title = None
    current_description = ""
    current_ingredients = []
    current_steps = []
    sequence_counter = {}
    
    i = 0
    while i < len(lines):
        line = lines[i].strip()
        
        # Skip empty lines
        if not line:
            i += 1
            continue
        
        # Detect section headers
        upper_line = line.upper()
        
        # Philippines Main
        if 'PHILIPPINES MAIN' in upper_line or 'FILIPINO MAIN' in upper_line:
            current_region = 'Philippines'
            current_course = 'Main Course'
            current_section = 'recipes'
            i += 1
            continue
        elif 'PHILIPPINES DESSERTS' in upper_line or 'FILIPINO DESSERTS' in upper_line:
            current_region = 'Philippines'
            current_course = 'Dessert'
            current_section = 'recipes'
            i += 1
            continue
        elif 'PHILIPPINES BEVERAGES' in upper_line or 'FILIPINO BEVERAGES' in upper_line:
            current_region = 'Philippines'
            current_course = 'Beverage'
            current_section = 'recipes'
            i += 1
            continue
        
        # Korea
        elif 'KOREAN MAIN' in upper_line:
            current_region = 'South Korea'
            current_course = 'Main Course'
            current_section = 'recipes'
            i += 1
            continue
        elif 'KOREAN DESSERTS' in upper_line:
            current_region = 'South Korea'
            current_course = 'Dessert'
            current_section = 'recipes'
            i += 1
            continue
        elif 'KOREAN BEVERAGES' in upper_line:
            current_region = 'South Korea'
            current_course = 'Beverage'
            current_section = 'recipes'
            i += 1
            continue
        
        # Japan
        elif 'JAPAN MAIN' in upper_line or 'JAPANESE MAIN' in upper_line:
            current_region = 'Japan'
            current_course = 'Main Course'
            current_section = 'recipes'
            i += 1
            continue
        elif 'JAPAN DESSERTS' in upper_line or 'JAPANESE DESSERTS' in upper_line:
            current_region = 'Japan'
            current_course = 'Dessert'
            current_section = 'recipes'
            i += 1
            continue
        elif 'JAPAN BEVERAGES' in upper_line or 'JAPANESE BEVERAGES' in upper_line:
            current_region = 'Japan'
            current_course = 'Beverage'
            current_section = 'recipes'
            i += 1
            continue
        
        # China
        elif 'CHINA MAIN' in upper_line or 'CHINESE MAIN' in upper_line:
            current_region = 'China'
            current_course = 'Main Course'
            current_section = 'recipes'
            i += 1
            continue
        elif 'CHINA DESSERTS' in upper_line or 'CHINESE DESSERTS' in upper_line:
            current_region = 'China'
            current_course = 'Dessert'
            current_section = 'recipes'
            i += 1
            continue
        elif 'CHINA BEVERAGES' in upper_line or 'CHINESE BEVERAGES' in upper_line:
            current_region = 'China'
            current_course = 'Beverage'
            current_section = 'recipes'
            i += 1
            continue
        
        # Indonesia
        elif 'INDONESIA MAIN' in upper_line or 'INDONESIAN MAIN' in upper_line:
            current_region = 'Indonesia'
            current_course = 'Main Course'
            current_section = 'recipes'
            i += 1
            continue
        elif 'INDONESIA DESSERTS' in upper_line or 'INDONESIAN DESSERTS' in upper_line:
            current_region = 'Indonesia'
            current_course = 'Dessert'
            current_section = 'recipes'
            i += 1
            continue
        elif 'INDONESIA BEVERAGES' in upper_line or 'INDONESIAN BEVERAGES' in upper_line:
            current_region = 'Indonesia'
            current_course = 'Beverage'
            current_section = 'recipes'
            i += 1
            continue
        
        # Nigeria
        elif 'NIGERIA MAIN' in upper_line or 'NIGERIAN MAIN' in upper_line:
            current_region = 'Nigeria'
            current_course = 'Main Course'
            current_section = 'recipes'
            i += 1
            continue
        elif 'NIGERIA DESSERTS' in upper_line or 'NIGERIAN DESSERTS' in upper_line:
            current_region = 'Nigeria'
            current_course = 'Dessert'
            current_section = 'recipes'
            i += 1
            continue
        elif 'NIGERIA BEVERAGES' in upper_line or 'NIGERIAN BEVERAGES' in upper_line:
            current_region = 'Nigeria'
            current_course = 'Beverage'
            current_section = 'recipes'
            i += 1
            continue
        
        # South Africa
        elif 'SOUTH AFRICA MAIN' in upper_line or 'SOUTH AFRICAN MAIN' in upper_line:
            current_region = 'South Africa'
            current_course = 'Main Course'
            current_section = 'recipes'
            i += 1
            continue
        elif 'SOUTH AFRICA DESSERTS' in upper_line or 'SOUTH AFRICAN DESSERTS' in upper_line:
            current_region = 'South Africa'
            current_course = 'Dessert'
            current_section = 'recipes'
            i += 1
            continue
        elif 'SOUTH AFRICA BEVERAGES' in upper_line or 'SOUTH AFRICAN BEVERAGES' in upper_line:
            current_region = 'South Africa'
            current_course = 'Beverage'
            current_section = 'recipes'
            i += 1
            continue
        
        # Egypt
        elif 'EGYPT MAIN' in upper_line or 'EGYPTIAN MAIN' in upper_line:
            current_region = 'Egypt'
            current_course = 'Main Course'
            current_section = 'recipes'
            i += 1
            continue
        elif 'EGYPT DESSERTS' in upper_line or 'EGYPTIAN DESSERTS' in upper_line:
            current_region = 'Egypt'
            current_course = 'Dessert'
            current_section = 'recipes'
            i += 1
            continue
        elif 'EGYPT BEVERAGES' in upper_line or 'EGYPTIAN BEVERAGES' in upper_line:
            current_region = 'Egypt'
            current_course = 'Beverage'
            current_section = 'recipes'
            i += 1
            continue
        
        # Australia
        elif 'AUSTRALIA MAIN' in upper_line or 'AUSTRALIAN MAIN' in upper_line:
            current_region = 'Australia'
            current_course = 'Main Course'
            current_section = 'recipes'
            i += 1
            continue
        elif 'AUSTRALIA DESSERTS' in upper_line or 'AUSTRALIAN DESSERTS' in upper_line:
            current_region = 'Australia'
            current_course = 'Dessert'
            current_section = 'recipes'
            i += 1
            continue
        elif 'AUSTRALIA BEVERAGES' in upper_line or 'AUSTRALIAN BEVERAGES' in upper_line:
            current_region = 'Australia'
            current_course = 'Beverage'
            current_section = 'recipes'
            i += 1
            continue
        
        # New Zealand
        elif 'NEW ZEALAND MAIN' in upper_line:
            current_region = 'New Zealand'
            current_course = 'Main Course'
            current_section = 'recipes'
            i += 1
            continue
        elif 'NEW ZEALAND DESSERTS' in upper_line:
            current_region = 'New Zealand'
            current_course = 'Dessert'
            current_section = 'recipes'
            i += 1
            continue
        elif 'NEW ZEALAND BEVERAGES' in upper_line:
            current_region = 'New Zealand'
            current_course = 'Beverage'
            current_section = 'recipes'
            i += 1
            continue
        
        # Fiji
        elif 'FIJI MAIN' in upper_line:
            current_region = 'Fiji'
            current_course = 'Main Course'
            current_section = 'recipes'
            i += 1
            continue
        elif 'FIJI DESSERTS' in upper_line:
            current_region = 'Fiji'
            current_course = 'Dessert'
            current_section = 'recipes'
            i += 1
            continue
        elif 'FIJI BEVERAGES' in upper_line:
            current_region = 'Fiji'
            current_course = 'Beverage'
            current_section = 'recipes'
            i += 1
            continue
        
        # France
        elif 'FRANCE MAIN' in upper_line or 'FRENCH MAIN' in upper_line:
            current_region = 'France'
            current_course = 'Main Course'
            current_section = 'recipes'
            i += 1
            continue
        elif 'FRANCE DESSERTS' in upper_line or 'FRENCH DESSERTS' in upper_line:
            current_region = 'France'
            current_course = 'Dessert'
            current_section = 'recipes'
            i += 1
            continue
        elif 'FRANCE BEVERAGES' in upper_line or 'FRENCH BEVERAGES' in upper_line:
            current_region = 'France'
            current_course = 'Beverage'
            current_section = 'recipes'
            i += 1
            continue
        
        # Germany
        elif 'GERMANY MAIN' in upper_line or 'GERMAN MAIN' in upper_line:
            current_region = 'Germany'
            current_course = 'Main Course'
            current_section = 'recipes'
            i += 1
            continue
        elif 'GERMANY DESSERTS' in upper_line or 'GERMAN DESSERTS' in upper_line:
            current_region = 'Germany'
            current_course = 'Dessert'
            current_section = 'recipes'
            i += 1
            continue
        elif 'GERMANY BEVERAGES' in upper_line or 'GERMAN BEVERAGES' in upper_line:
            current_region = 'Germany'
            current_course = 'Beverage'
            current_section = 'recipes'
            i += 1
            continue
        
        # Italy
        elif 'ITALY MAIN' in upper_line or 'ITALIAN MAIN' in upper_line:
            current_region = 'Italy'
            current_course = 'Main Course'
            current_section = 'recipes'
            i += 1
            continue
        elif 'ITALY DESSERTS' in upper_line or 'ITALIAN DESSERTS' in upper_line:
            current_region = 'Italy'
            current_course = 'Dessert'
            current_section = 'recipes'
            i += 1
            continue
        elif 'ITALY BEVERAGES' in upper_line or 'ITALIAN BEVERAGES' in upper_line:
            current_region = 'Italy'
            current_course = 'Beverage'
            current_section = 'recipes'
            i += 1
            continue
        
        # Canada
        elif 'CANADA MAIN' in upper_line or 'CANADIAN MAIN' in upper_line:
            current_region = 'Canada'
            current_course = 'Main Course'
            current_section = 'recipes'
            i += 1
            continue
        elif 'CANADA DESSERTS' in upper_line or 'CANADIAN DESSERTS' in upper_line:
            current_region = 'Canada'
            current_course = 'Dessert'
            current_section = 'recipes'
            i += 1
            continue
        elif 'CANADA BEVERAGES' in upper_line or 'CANADIAN BEVERAGES' in upper_line:
            current_region = 'Canada'
            current_course = 'Beverage'
            current_section = 'recipes'
            i += 1
            continue
        
        # United States
        elif 'UNITED STATES MAIN' in upper_line or 'AMERICAN MAIN' in upper_line:
            current_region = 'United States'
            current_course = 'Main Course'
            current_section = 'recipes'
            i += 1
            continue
        elif 'UNITED STATES DESSERTS' in upper_line or 'AMERICAN DESSERTS' in upper_line:
            current_region = 'United States'
            current_course = 'Dessert'
            current_section = 'recipes'
            i += 1
            continue
        elif 'UNITED STATES BEVERAGES' in upper_line or 'AMERICAN BEVERAGES' in upper_line:
            current_region = 'United States'
            current_course = 'Beverage'
            current_section = 'recipes'
            i += 1
            continue
        
        # Mexico
        elif 'MEXICO MAIN' in upper_line or 'MEXICAN MAIN' in upper_line:
            current_region = 'Mexico'
            current_course = 'Main Course'
            current_section = 'recipes'
            i += 1
            continue
        elif 'MEXICO DESSERTS' in upper_line or 'MEXICAN DESSERTS' in upper_line:
            current_region = 'Mexico'
            current_course = 'Dessert'
            current_section = 'recipes'
            i += 1
            continue
        elif 'MEXICO BEVERAGES' in upper_line or 'MEXICAN BEVERAGES' in upper_line:
            current_region = 'Mexico'
            current_course = 'Beverage'
            current_section = 'recipes'
            i += 1
            continue
        
        # Brazil
        elif 'BRAZIL MAIN' in upper_line or 'BRAZILIAN MAIN' in upper_line:
            current_region = 'Brazil'
            current_course = 'Main Course'
            current_section = 'recipes'
            i += 1
            continue
        elif 'BRAZIL DESSERTS' in upper_line or 'BRAZILIAN DESSERTS' in upper_line:
            current_region = 'Brazil'
            current_course = 'Dessert'
            current_section = 'recipes'
            i += 1
            continue
        elif 'BRAZIL BEVERAGES' in upper_line or 'BRAZILIAN BEVERAGES' in upper_line:
            current_region = 'Brazil'
            current_course = 'Beverage'
            current_section = 'recipes'
            i += 1
            continue
        
        # Argentina
        elif 'ARGENTINA MAIN' in upper_line or 'ARGENTINE MAIN' in upper_line or 'ARGENTINIAN MAIN' in upper_line:
            current_region = 'Argentina'
            current_course = 'Main Course'
            current_section = 'recipes'
            i += 1
            continue
        elif 'ARGENTINA DESSERTS' in upper_line or 'ARGENTINE DESSERTS' in upper_line:
            current_region = 'Argentina'
            current_course = 'Dessert'
            current_section = 'recipes'
            i += 1
            continue
        elif 'ARGENTINA BEVERAGES' in upper_line or 'ARGENTINE BEVERAGES' in upper_line:
            current_region = 'Argentina'
            current_course = 'Beverage'
            current_section = 'recipes'
            i += 1
            continue
        
        # Chile
        elif 'CHILE MAIN' in upper_line or 'CHILEAN MAIN' in upper_line:
            current_region = 'Chile'
            current_course = 'Main Course'
            current_section = 'recipes'
            i += 1
            continue
        elif 'CHILE DESSERTS' in upper_line or 'CHILEAN DESSERTS' in upper_line:
            current_region = 'Chile'
            current_course = 'Dessert'
            current_section = 'recipes'
            i += 1
            continue
        elif 'CHILE BEVERAGES' in upper_line or 'CHILEAN BEVERAGES' in upper_line:
            current_region = 'Chile'
            current_course = 'Beverage'
            current_section = 'recipes'
            i += 1
            continue
        
        # Recipe title detection (starts with number like "1. Adobo")
        title_match = re.match(r'^(\d+)\.\s+(.+?)(?:\s*[-–]\s*(.*))?$', line)
        if title_match and current_section == 'recipes':
            # Save previous recipe
            if current_title and current_ingredients:
                key = f"{current_region}_{current_course}"
                if key not in sequence_counter:
                    sequence_counter[key] = 0
                sequence_counter[key] += 1
                dish_id = generate_dish_id(current_region, current_course, sequence_counter[key])
                
                output_lines.append(f"[DISH_ID:{dish_id}]")
                output_lines.append(f"[TITLE:{current_title}]")
                output_lines.append(f"[CATEGORY:{current_region}]")
                output_lines.append(f"[SUBCATEGORY:{current_region} {current_course}]")
                
                # Convert ingredients list to pipe-separated string
                ingredients_str = '|'.join(current_ingredients)
                output_lines.append(f"[INGREDIENTS:{ingredients_str}]")
                
                # Convert steps list to pipe-separated numbered string
                steps_str = '|'.join([f"{j+1}. {step}" for j, step in enumerate(current_steps)])
                output_lines.append(f"[PROCEDURE:{steps_str}]")
                output_lines.append("")
            
            # Start new recipe
            current_title = title_match.group(2).strip()
            current_description = title_match.group(3).strip() if title_match.group(3) else ""
            current_ingredients = []
            current_steps = []
            
            i += 1
            continue
        
        # Collect ingredients (lines starting with *)
        if current_section == 'recipes' and current_title and line.startswith('*'):
            ing = line.lstrip('* ').strip()
            if ing and not ing.upper().startswith('PROCEDURE'):
                current_ingredients.append(ing)
            i += 1
            continue
        
        # Collect steps (numbered lines or text after "Procedure")
        if current_section == 'recipes' and current_title and line and not line.startswith('*'):
            # Skip headers
            if 'INGREDIENTS' in upper_line or 'PROCEDURE' in upper_line:
                i += 1
                continue
            
            # Skip standalone numbers or short markers
            if line.isdigit() or len(line) < 3:
                i += 1
                continue
            
            # Clean step text
            step = re.sub(r'^\d+\.\s*', '', line).strip()
            if step and not step.upper().startswith('SERVE'):
                current_steps.append(step)
            elif step and len(current_steps) > 0:
                current_steps[-1] += " " + step
        
        i += 1
    
    # Save last recipe
    if current_title and current_ingredients:
        key = f"{current_region}_{current_course}"
        if key not in sequence_counter:
            sequence_counter[key] = 0
        sequence_counter[key] += 1
        dish_id = generate_dish_id(current_region, current_course, sequence_counter[key])
        
        output_lines.append(f"[DISH_ID:{dish_id}]")
        output_lines.append(f"[TITLE:{current_title}]")
        output_lines.append(f"[CATEGORY:{current_region}]")
        output_lines.append(f"[SUBCATEGORY:{current_region} {current_course}]")
        ingredients_str = '|'.join(current_ingredients)
        output_lines.append(f"[INGREDIENTS:{ingredients_str}]")
        steps_str = '|'.join([f"{j+1}. {step}" for j, step in enumerate(current_steps)])
        output_lines.append(f"[PROCEDURE:{steps_str}]")
        output_lines.append("")
    
    # Write output file
    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        f.write('\n'.join(output_lines))
    
    print(f"✅ Conversion complete!")
    print(f"   Input: {INPUT_FILE}")
    print(f"   Output: {OUTPUT_FILE}")
    print(f"   Total recipes converted: {sum(sequence_counter.values())}")
    
    # Print counts by type
    print("\n📊 Recipe counts by type:")
    for key, count in sorted(sequence_counter.items()):
        print(f"   {key}: {count}")

if __name__ == '__main__':
    parse_old_format_to_new()