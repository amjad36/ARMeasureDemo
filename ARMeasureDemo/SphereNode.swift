//
//  SphereNode.swift
//  ARMeasureDemo
//
//  Created by Amjad Khan on 27/11/17.
//  Copyright © 2017 HCL. All rights reserved.
//

import SceneKit

class SphereNode: SCNNode {

    init(position: SCNVector3) {
        super.init()
        let sphereGeometry = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        material.lightingModel = .physicallyBased
        sphereGeometry.materials = [material]
        self.geometry = sphereGeometry
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
