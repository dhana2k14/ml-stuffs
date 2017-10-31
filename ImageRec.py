
from PIL import Image
import numpy as np

i = Image.open('images/dotndot.png')
iar = np.asarray(i)

print iar