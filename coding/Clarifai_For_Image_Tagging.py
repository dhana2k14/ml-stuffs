import pandas as pd
from clarifai.client import ClarifaiApi
import PIL, os
from bson import json_util, ObjectId
from pandas.io.json import json_normalize
import json
import itertools
from pandas import DataFrame

clarifai_api = ClarifaiApi('<Client Id>','<Client Secret>')

result = clarifai_api.tag_images([open('<path to image file 1>', 'rb'), 
                                  open('<path to image file 2>', 'rb'),
                                  open('<path to image file 3>', 'rb')])
sanitized = json.loads(json_util.dumps(result['results']))
normalized = json_normalize(sanitized)
df = pd.DataFrame(normalized)

res = df.to_dict()
data = []

for x in res['docid'].keys():
    data.append(itertools.izip_longest([res['docid_str'][x]],  res['result.tag.classes'][x], res['result.tag.concept_ids'][x], res['result.tag.probs'][x], fillvalue = res['docid_str'][x]))

new_data = list(itertools.chain.from_iterable(data))
df3 = DataFrame(new_data, columns = ['docid_str', 'tag_class', 'tag_concept', 'tag_probs'])

print df3
								  