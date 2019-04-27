import pycountry
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

def get_full_country(alpha_2_code):
    """Returns the name of a country from the 2-letter ISO code
    """
    try:
        return pycountry.countries.get(alpha_2=alpha_2_code).name
    except AttributeError:
        return np.NaN

def add_full_country_name(frame,
                          country_2letter_col = 'country',
                          full_country_col_name='country_full_name',
                          code_country_name = True):
    frame[full_country_col_name] = frame[country_2letter_col].apply(get_full_country)
    if code_country_name:
        frame['code-country'] = frame['country'] + '-' + frame['country_full_name']
    return frame

def clean_drop_le0(frame, value_col_name='value', le0_value=np.NaN):
    return frame.where(frame[value_col_name] > 0, other=le0_value)

def clean_oaq(frame):
    frame = clean_drop_le0(frame)
    return frame

def analyze_yearly_country_value(frame):
    frame_agg = frame.groupby('country')['value'].mean().sort_values().reset_index()
    frame_agg = add_full_country_name(frame_agg)
    return frame_agg

def plot_year_agg(y_agg, global_avg):
    fig, ax = plt.subplots(1, 1, figsize=[13, 21])
    sns.barplot(x = y_agg.value, y = y_agg['code-country'], color = 'black', ax=ax)
    ax.axvline(global_avg, color='red')
    #return(fig)
