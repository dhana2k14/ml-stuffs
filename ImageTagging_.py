## Load Libraries

import pandas as pd
from clarifai.client import ClarifaiApi
import PIL, json, itertools
from bson import json_util, ObjectId
from pandas.io.json import json_normalize
from pandas import DataFrame

clarifai_api = ClarifaiApi('T3DIgYtEokkSCQnGMNpd58cofZZJ123zmpJpbiHy','LgpBH4KHlSx0MVtu1dte-N10eIxlBwm_HPhW627z')

# result = clarifai_api.tag_image_urls(['http://www.gstatic.com/webp/gallery/1.jpg', 
                                  # 'http://www.gstatic.com/webp/gallery/2.jpg',
								  # 'http://www.gstatic.com/webp/gallery/3.jpg',
								  # 'http://www.gstatic.com/webp/gallery/4.jpg',
								  # 'http://www.gstatic.com/webp/gallery/5.jpg'])
								  
								  
result = clarifai_api.tag_images([open('D:\Kaggle\OCR\Watermark\chest-xray-111026-02.jpg', 'rb'),
								  open('D:\\Kaggle\\OCR\\Watermark\\3.jpg', 'rb')])
								  
sanitized = json.loads(json_util.dumps(result['results']))
normalized = json_normalize(sanitized)
df = pd.DataFrame(normalized)

res = df.to_dict()
data = []

for x in res['docid_str'].keys():
    data.append(itertools.izip_longest([res['docid_str'][x]],  res['result.tag.classes'][x], res['result.tag.concept_ids'][x], res['result.tag.probs'][x], fillvalue = res['docid_str'][x]))

new_data = list(itertools.chain.from_iterable(data))
result = DataFrame(new_data, columns = ['docid_str', 'tag_class', 'tag_concept', 'tag_probs'])
print result