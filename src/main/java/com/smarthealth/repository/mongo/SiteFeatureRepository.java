package com.smarthealth.repository.mongo;

import com.smarthealth.model.mongo.SiteFeature;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SiteFeatureRepository extends MongoRepository<SiteFeature, String> {
}
