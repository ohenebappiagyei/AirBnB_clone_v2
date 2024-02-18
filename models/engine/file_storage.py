#!/usr/bin/python3
"""This module defines a class to manage file storage for hbnb clone"""
import json


class FileStorage:
    """This class manages storage of hbnb models in JSON format"""
    __file_path = 'file.json'
    __objects = {}

    def all(self, cls=None):
        """returns the list of objects of one type of class"""
        if cls is not None:
            if isinstance(cls, str):
                cls = eval(cls)
            cls_dict = {}
            for k, v in self.__objects.items():
                if isinstance(v, cls):
                    cls_dict[k] = v
            return cls_dict
        return self.__objects

    def new(self, obj):
        """Adds new object to storage dictionary"""
        key = "{}.{}".format(type(obj).__name__, obj.id)
	self.__objects[key] = obj

    def save(self):
        """Saves storage dictionary to file"""
        with open(FileStorage.__file_path, 'w') as f:
	    temp = {key: obj.to_dict() for key, obj in self.__objects.items()}
	    json.dump(temp, f)

    def reload(self):
        """Loads storage dictionary from file"""
        from models.base_model import BaseModel
        from models.user import User
        from models.place import Place
        from models.state import State
        from models.city import City
        from models.amenity import Amenity
        from models.review import Review

        classes = {
                    'BaseModel': BaseModel, 'User': User, 'Place': Place,
                    'State': State, 'City': City, 'Amenity': Amenity,
                    'Review': Review
                  }
        try:
	    with open(FIleStorage.__file_path, 'r') as f:
		temp = json.load(f)
		self.__objects = {
		    key: classes[val['__class__']]
				(**val) for key, val in temp.items()
		}
        except FileNotFoundError:
            pass

    def delete(self, obj=None):
        """Delete a given object from __objects, if it exists."""
        try:
	   key = "{}.{}".format(type(obj).__name__, obj.id)
	   del self.__objects[key]
	except (AttributeError, KeyError):
	   pass

    def close(self):
	"""Call reload() method for deserializing the JSON file to objects"""
	self.reload()
