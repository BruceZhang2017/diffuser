//
//  FAQViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import Then
import SnapKit

class FAQViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bgView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.contentInsetAdjustmentBehavior = .never
        
        let bgImageView = UIImageView(image: UIImage(named: "rectangle20")).then {
            $0.contentMode = .scaleToFill
        }
        bgView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension FAQViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let lbl = cell.contentView.viewWithTag(1) as? UILabel {
            lbl.text = contents[indexPath.row][0]
        }
        if let lbl = cell.contentView.viewWithTag(2) as? UILabel {
            lbl.text = contents[indexPath.row][1]
        }
        cell.selectionStyle = .none
        return cell
    }
    
    
}

extension FAQViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FAQViewController {
    var contents: [[String]] {
        return [["What is the size of the hole in the ductwork?","The proper drill size is 3/8″, if you don’t have that size then you can take the drill bit you do have and wiggle it around the hole to slowly increase the hole size."],
                ["Where does my diffuser go?","Your diffuser should be within the tube’s reach of the outflow ductwork. You can mount it to the wall or place it on a shelf. Make sure that the tube is going straight up into the ductwork and doesn’t bend or loop itself."],
                ["My HVAC is in the attic, what can I do?","High temperature can affect the fragrances and change how they smell. We recommend placing the diffuser in a room or access point below the attic and installing a longer tube to run through the ceiling and into the HVAC. The diffuser is capable of pushing the scent up to 15’."],

                ["Will the hole affect my HVAC ductwork?","No, the hole will not affect your ductwork or the efficiency of your system. HVAC technicians will create them to test your air flow so your system may already have a similar hole."],
                ["If I move can I take the unit with me?","Yes! Of course. Just turn off the diffuser, pull the tube out of the duct work, and take the diffuser off the wall and to your new house!"],
                ["How long does installation take?",
                "Installation is quick and easy. For most people it takes under 15 minutes."],
                ["The scent is faint even on the highest setting, what do I do?",
                "If your scent is faint no matter what you do then try these quick fixes: make sure all your vents are open and turn your HVAC system’s fan to the “ON” setting. Is the atomizer pushed all the way in and locked into place? Is the dipstick still attached to the fragrance bottle inside the diffuser?"],
                ["How long is the tube?","The tube is 3 feet long and ⅜”. The diffuser can push the fragrance mist up to 15’."],
                ["Should the atomizer be locked into place?","Locking the atomizer lid is the best way to keep the diffuser from getting out of place and not being able to diffuse properly."],
                ["I don't have anywhere to mount my diffuser in my utility room...","The diffuser can also be placed on a shelf or be sitting on the ground. Just make sure it is away from water, heat, children, and pets."],
                ["My diffuser is not diffusing / there is no fragrance mist","This note depends on new diffuser If the fan is spinning and you can see fragrance mist, but still unable to smell anything, you may have gone nose blind."],
                ["Still have Questions?","To speak to one of our agents please call us at (855) 723-6863 or you can email support@wholehomescenting.com."]

]
    }
}
