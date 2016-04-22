//
//  YATWUtils.h
//  Pods
//
//  Created by Sergey Fedortsov on 22.4.16.
//
//


#include <yaml-cpp/yaml.h>

namespace yaml_that_works {
    static inline bool IsBinary(const YAML::Node& node)
    {
        return node.Tag() == "tag:yaml.org,2002:binary";
    }
    
    static inline bool IsBool(const YAML::Node& node)
    {
        return node.Tag() == "tag:yaml.org,2002:bool";
    }
    
    static inline bool IsFloat(const YAML::Node& node)
    {
        return node.Tag() == "tag:yaml.org,2002:float";
    }
    
    static inline bool IsInt(const YAML::Node& node)
    {
        return node.Tag() == "tag:yaml.org,2002:int";
    }
    
    static inline bool IsTimestamp(const YAML::Node& node)
    {
        return node.Tag() == "tag:yaml.org,2002:timestamp";
    }
    
    
    static inline bool IsSet(const YAML::Node& node)
    {
        return node.Tag() == "tag:yaml.org,2002:set";
    }
    
    static inline bool IsPairs(const YAML::Node& node)
    {
        return node.Tag() == "tag:yaml.org,2002:pairs";
    }
    
}
