def splitRows(x):
    result = pd.DataFrame()
    for k in range(len(x['docid'])):
        tag_class = x['result.tag.classes'].iloc[0]
        a_lst = list()
        for i, val in enumerate(tag_class):
            tagRow = dict()
            tagRow['docid'] = x['docid'][k]
            tagRow['index'] = i
            tagRow['tag_class'] = val
            a_lst.append(tagRow)
        a_lst = pd.DataFrame(a_lst)
        
        tag_concept = x['result.tag.concept_ids'].iloc[0]
        b_lst = list()
        for i, val in enumerate(tag_concept):
            conceptRow = dict()
            conceptRow['docid'] = x['docid'][k]
            conceptRow['index'] = i
            conceptRow['tag_concept'] = val
            b_lst.append(conceptRow)
        b_lst = pd.DataFrame(b_lst)
        
        tag_probs = x['result.tag.probs'].iloc[0]
        c_lst = list()
        for i, val in enumerate(tag_probs):
            probRow = dict()
            probRow['docid'] = x['docid'][k]
            probRow['index'] = i
            probRow['tag_probs'] = val
            c_lst.append(probRow)
        c_lst = pd.DataFrame(c_lst)
    return c_lst

#     return a_lst.merge(b_lst,on = 'index').merge(c_lst, on = 'index')
        #return result